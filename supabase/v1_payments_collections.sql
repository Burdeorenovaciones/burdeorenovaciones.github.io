-- Burdeo Renovaciones V1 — Pagos y cobranza
-- Supabase almacena SOLO datos estructurados y referencias documentales.
-- Los comprobantes originales quedan en Google Drive privado vía v1_document_references.

create table if not exists public.v1_project_payments (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  project_id uuid not null,
  payment_type text not null check (payment_type in ('ANTICIPO','ABONO','PAGO_FINAL','OTRO')),
  payment_date date not null,
  amount numeric(14,2) not null check (amount > 0),
  payment_method text not null default 'TRANSFERENCIA',
  external_reference text,
  receipt_document_id uuid,
  status text not null default 'CONFIRMADO' check (status in ('CONFIRMADO','REVERSADO')),
  note text,
  reversed_at timestamptz,
  reversal_reason text,
  created_at timestamptz not null default now(),
  created_by uuid,
  updated_at timestamptz not null default now()
);

create index if not exists v1_project_payments_project_idx
  on public.v1_project_payments (organization_id, project_id, payment_date desc);

-- FK se agrega sólo si la tabla documental común ya existe en el mismo entorno.
do $$
begin
  if to_regclass('public.v1_document_references') is not null and not exists (
    select 1 from pg_constraint where conname='v1_project_payments_receipt_document_fk'
  ) then
    alter table public.v1_project_payments
      add constraint v1_project_payments_receipt_document_fk
      foreign key (receipt_document_id) references public.v1_document_references(id);
  end if;
end $$;

-- Vista staging de cobranza. Espera que v1_project_quote_baselines / vista equivalente
-- entregue la venta vigente productiva en bloques posteriores; por ahora deja pagos agregados.
create or replace view public.v1_project_payment_totals as
select
  organization_id,
  project_id,
  coalesce(sum(amount) filter (where status='CONFIRMADO'),0)::numeric(14,2) as collected_amount,
  count(*) filter (where status='CONFIRMADO') as confirmed_payments,
  count(*) filter (where status='REVERSADO') as reversed_payments,
  max(payment_date) filter (where status='CONFIRMADO') as last_payment_date
from public.v1_project_payments
group by organization_id, project_id;

comment on column public.v1_project_payments.receipt_document_id is
'Referencia a metadatos de comprobante almacenado en Drive privado. Nunca binario/base64.';
