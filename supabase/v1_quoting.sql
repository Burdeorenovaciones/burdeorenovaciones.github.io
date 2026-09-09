-- Burdeo Renovaciones V1 — Cotizador estructurado (staging)
-- Supabase almacena datos; los PDF emitidos se referencian mediante v1_document_references y viven en Google Drive privado.

create table if not exists public.v1_quotes (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  project_id uuid not null,
  quote_number text not null,
  status text not null default 'draft' check (status in ('draft','sent','approved','rejected','expired')),
  version integer not null default 1 check (version > 0),
  indirect_pct numeric(7,4) not null default 0 check (indirect_pct >= 0),
  target_margin_pct numeric(7,4) not null default 0 check (target_margin_pct >= 0 and target_margin_pct < 100),
  vat_pct numeric(7,4) not null default 19 check (vat_pct >= 0),
  direct_cost numeric(14,2) not null default 0,
  indirect_cost numeric(14,2) not null default 0,
  budget_cost numeric(14,2) not null default 0,
  suggested_net numeric(14,2) not null default 0,
  customer_net numeric(14,2) not null default 0,
  vat_amount numeric(14,2) not null default 0,
  customer_total numeric(14,2) not null default 0,
  effective_margin_pct numeric(7,4) not null default 0,
  customer_pdf_document_id uuid null references public.v1_document_references(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid null,
  unique (organization_id, quote_number, version)
);

create table if not exists public.v1_quote_lines (
  id uuid primary key default gen_random_uuid(),
  quote_id uuid not null references public.v1_quotes(id) on delete cascade,
  line_no integer not null,
  cost_family text not null check (cost_family in ('furniture','materials','hardware','labor','installation','transport','food_direct','subcontract','other_direct')),
  description text not null,
  quantity numeric(14,4) not null default 1 check (quantity >= 0),
  unit text null,
  unit_cost numeric(14,2) not null default 0 check (unit_cost >= 0),
  line_cost numeric(14,2) generated always as (round(quantity * unit_cost, 2)) stored,
  material_variant_id uuid null,
  material_cost_snapshot numeric(14,2) null,
  material_price_date date null,
  created_at timestamptz not null default now(),
  unique (quote_id, line_no)
);

create or replace view public.v1_quote_qa as
select q.id,
       q.quote_number,
       q.version,
       q.direct_cost,
       coalesce(sum(l.line_cost),0) as lines_direct_cost,
       q.indirect_cost,
       q.budget_cost,
       q.customer_net,
       q.vat_amount,
       q.customer_total,
       abs(q.direct_cost - coalesce(sum(l.line_cost),0)) < 1 as direct_cost_ok,
       abs(q.budget_cost - (q.direct_cost + q.indirect_cost)) < 1 as budget_cost_ok,
       abs(q.customer_total - (q.customer_net + q.vat_amount)) < 1 as total_ok
from public.v1_quotes q
left join public.v1_quote_lines l on l.quote_id = q.id
group by q.id;

comment on table public.v1_quotes is 'Cotizaciones V1 estructuradas. No almacenar PDF/binarios aquí; usar customer_pdf_document_id hacia Drive privado.';
comment on table public.v1_quote_lines is 'Partidas/costos V1 con snapshot del costo usado para presupuestar cuando provenga del catálogo de materiales.';