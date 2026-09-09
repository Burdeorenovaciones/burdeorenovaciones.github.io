-- Burdeo Renovaciones V1 - versiones cliente de cotización
-- Solo datos estructurados. El PDF físico vive en Google Drive privado.
create table if not exists v1_quote_customer_versions (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  project_id uuid not null,
  quote_id uuid not null,
  version integer not null check (version > 0),
  customer_name text not null,
  issued_at timestamptz not null default now(),
  valid_days integer not null default 15 check (valid_days > 0),
  payment_terms text,
  customer_notes text,
  net_amount numeric(14,2) not null check (net_amount >= 0),
  vat_rate numeric(7,4) not null default 19,
  vat_amount numeric(14,2) not null check (vat_amount >= 0),
  total_amount numeric(14,2) not null check (total_amount >= 0),
  document_reference_id uuid null references v1_document_references(id),
  drive_file_id text null,
  status text not null default 'ISSUED' check (status in ('ISSUED','SENT','APPROVED','VOID')),
  created_by uuid null,
  created_at timestamptz not null default now(),
  unique (organization_id, quote_id, version)
);

create table if not exists v1_quote_customer_version_lines (
  id uuid primary key default gen_random_uuid(),
  customer_version_id uuid not null references v1_quote_customer_versions(id) on delete restrict,
  line_no integer not null,
  description text not null,
  quantity numeric(14,3) not null default 1,
  commercial_amount numeric(14,2) null,
  created_at timestamptz not null default now(),
  unique(customer_version_id,line_no)
);

-- Una versión emitida no se actualiza: correcciones generan una nueva versión.
create or replace view v1_quote_customer_versions_qa as
select v.id, v.quote_id, v.version, v.net_amount, v.vat_amount, v.total_amount,
       round(v.net_amount + v.vat_amount,2) as calculated_total,
       case when round(v.net_amount + v.vat_amount,2)=round(v.total_amount,2) then 'OK' else 'REVIEW' end as total_check,
       case when v.drive_file_id is null then 'PENDING_DRIVE' else 'REFERENCED' end as document_check
from v1_quote_customer_versions v;

comment on table v1_quote_customer_versions is 'Snapshot comercial inmutable por versión; PDF físico en Drive privado.';
comment on column v1_quote_customer_versions.drive_file_id is 'ID privado de Google Drive; nunca URL pública persistente.';
