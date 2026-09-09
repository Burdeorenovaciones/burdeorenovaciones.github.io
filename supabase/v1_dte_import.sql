-- Burdeo Renovaciones V1 — DTE SII estructurado
-- XML original: Google Drive privado. PostgreSQL: solo datos parseados, hash y referencia documental.

create table if not exists public.v1_dte_documents (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  recipient_rut text not null,
  issuer_rut text not null,
  issuer_name text null,
  dte_type integer not null,
  folio bigint not null,
  issue_date date not null,
  net_amount numeric(14,2) not null default 0,
  vat_amount numeric(14,2) not null default 0,
  exempt_amount numeric(14,2) not null default 0,
  total_amount numeric(14,2) not null default 0,
  xml_sha256 text not null check (xml_sha256 ~ '^[0-9a-fA-F]{64}$'),
  original_document_id uuid null references public.v1_document_references(id),
  import_status text not null default 'imported' check (import_status in ('review','imported','duplicate','rejected','error')),
  created_at timestamptz not null default now(),
  created_by uuid null,
  unique (organization_id, recipient_rut, issuer_rut, dte_type, folio),
  unique (organization_id, xml_sha256)
);

create table if not exists public.v1_dte_lines (
  id uuid primary key default gen_random_uuid(),
  dte_id uuid not null references public.v1_dte_documents(id) on delete cascade,
  line_number integer not null,
  item_code text null,
  description text not null,
  quantity numeric(14,4) null,
  unit text null,
  unit_price numeric(14,4) null,
  discount_amount numeric(14,2) not null default 0,
  line_amount numeric(14,2) not null default 0,
  unique (dte_id, line_number)
);

create table if not exists public.v1_dte_references (
  id uuid primary key default gen_random_uuid(),
  dte_id uuid not null references public.v1_dte_documents(id) on delete cascade,
  reference_line integer not null,
  referenced_dte_type integer null,
  referenced_folio text null,
  reference_date date null,
  reference_code integer null,
  reason text null,
  unique (dte_id, reference_line)
);

create index if not exists idx_v1_dte_org_date on public.v1_dte_documents(organization_id, issue_date desc);
create index if not exists idx_v1_dte_issuer on public.v1_dte_documents(organization_id, issuer_rut);

create or replace view public.v1_dte_qa as
select
  d.id,
  d.organization_id,
  d.issuer_rut,
  d.dte_type,
  d.folio,
  d.net_amount,
  d.vat_amount,
  d.exempt_amount,
  d.total_amount,
  coalesce(sum(l.line_amount),0) as lines_total,
  (d.net_amount + d.vat_amount + d.exempt_amount = d.total_amount) as tax_totals_ok,
  (coalesce(sum(l.line_amount),0) <= d.total_amount) as lines_not_over_total,
  (d.original_document_id is not null) as has_drive_reference
from public.v1_dte_documents d
left join public.v1_dte_lines l on l.dte_id = d.id
group by d.id;

comment on table public.v1_dte_documents is
'Structured SII DTE data only. Original XML must live in private Google Drive and be referenced via original_document_id.';
