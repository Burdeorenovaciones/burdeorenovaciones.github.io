-- Burdeo Renovaciones · V1 aprobación, línea base y adicionales
-- STAGING ONLY. No ejecutar en producción sin aprobación explícita.
-- Arquitectura: Supabase = datos estructurados; Drive privado = PDF/adjuntos.

create table if not exists v1_quote_approvals (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  project_id uuid not null,
  quote_id uuid not null,
  quote_customer_version_id uuid not null,
  approval_status text not null default 'approved' check (approval_status in ('approved','voided')),
  approved_at timestamptz not null default now(),
  approved_by_name text,
  approval_channel text check (approval_channel in ('email','whatsapp','firma','verbal','otro')),
  approval_reference text,
  approval_document_reference_id uuid,
  created_by uuid,
  created_at timestamptz not null default now(),
  voided_at timestamptz,
  void_reason text,
  unique (organization_id, quote_id)
);

create table if not exists v1_quote_baselines (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  project_id uuid not null,
  quote_id uuid not null,
  approval_id uuid not null references v1_quote_approvals(id),
  quote_customer_version_id uuid not null,
  baseline_version integer not null default 1,
  original_net numeric(14,2) not null check (original_net >= 0),
  original_vat numeric(14,2) not null check (original_vat >= 0),
  original_total numeric(14,2) not null check (original_total >= 0),
  budget_direct_cost numeric(14,2) not null check (budget_direct_cost >= 0),
  budget_indirect_cost numeric(14,2) not null check (budget_indirect_cost >= 0),
  budget_total_cost numeric(14,2) not null check (budget_total_cost >= 0),
  target_margin_pct numeric(8,4),
  expected_margin_pct numeric(8,4),
  internal_snapshot jsonb not null default '{}'::jsonb,
  commercial_snapshot jsonb not null default '{}'::jsonb,
  frozen_at timestamptz not null default now(),
  frozen_by uuid,
  unique (organization_id, quote_id),
  check (round(original_net + original_vat,2) = round(original_total,2)),
  check (round(budget_direct_cost + budget_indirect_cost,2) = round(budget_total_cost,2))
);

create table if not exists v1_change_orders (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  project_id uuid not null,
  baseline_id uuid not null references v1_quote_baselines(id),
  change_number integer not null,
  title text not null,
  description text,
  status text not null default 'draft' check (status in ('draft','sent','approved','rejected','voided')),
  net_amount numeric(14,2) not null default 0,
  vat_amount numeric(14,2) not null default 0,
  total_amount numeric(14,2) not null default 0,
  incremental_budget_cost numeric(14,2) not null default 0,
  expected_margin_pct numeric(8,4),
  customer_document_reference_id uuid,
  approval_document_reference_id uuid,
  sent_at timestamptz,
  approved_at timestamptz,
  approval_channel text check (approval_channel in ('email','whatsapp','firma','verbal','otro')),
  approval_reference text,
  created_by uuid,
  created_at timestamptz not null default now(),
  unique (organization_id, baseline_id, change_number),
  check (round(net_amount + vat_amount,2) = round(total_amount,2))
);

create table if not exists v1_change_order_lines (
  id uuid primary key default gen_random_uuid(),
  change_order_id uuid not null references v1_change_orders(id) on delete cascade,
  line_no integer not null,
  family text not null,
  description text not null,
  quantity numeric(14,4) not null default 1,
  unit_price_net numeric(14,2) not null default 0,
  line_net numeric(14,2) not null default 0,
  internal_unit_cost numeric(14,2) not null default 0,
  internal_line_cost numeric(14,2) not null default 0,
  unique (change_order_id, line_no)
);

create or replace view v1_project_sales_current as
select
  b.organization_id,
  b.project_id,
  b.id as baseline_id,
  b.original_net,
  b.original_vat,
  b.original_total,
  coalesce(sum(case when c.status='approved' then c.net_amount else 0 end),0) as approved_additional_net,
  coalesce(sum(case when c.status='approved' then c.vat_amount else 0 end),0) as approved_additional_vat,
  coalesce(sum(case when c.status='approved' then c.total_amount else 0 end),0) as approved_additional_total,
  b.original_net + coalesce(sum(case when c.status='approved' then c.net_amount else 0 end),0) as current_net,
  b.original_total + coalesce(sum(case when c.status='approved' then c.total_amount else 0 end),0) as current_total
from v1_quote_baselines b
left join v1_change_orders c on c.baseline_id=b.id
join v1_quote_approvals a on a.id=b.approval_id and a.approval_status='approved'
group by b.organization_id,b.project_id,b.id,b.original_net,b.original_vat,b.original_total;

create or replace view v1_quote_baseline_qa as
select
  b.id as baseline_id,
  b.project_id,
  b.quote_id,
  b.original_total,
  round(b.original_net+b.original_vat,2) as recomputed_original_total,
  b.budget_total_cost,
  round(b.budget_direct_cost+b.budget_indirect_cost,2) as recomputed_budget_cost,
  case when round(b.original_total,2)=round(b.original_net+b.original_vat,2) then 'OK' else 'ERROR_TOTAL' end as sales_check,
  case when round(b.budget_total_cost,2)=round(b.budget_direct_cost+b.budget_indirect_cost,2) then 'OK' else 'ERROR_COST' end as cost_check
from v1_quote_baselines b;

-- Regla V1: la línea base no se UPDATEA por cambios comerciales.
-- Después de aprobación, cualquier variación se registra en v1_change_orders.
-- PDF y respaldos de aprobación viven en Drive privado y se referencian por document_reference_id.