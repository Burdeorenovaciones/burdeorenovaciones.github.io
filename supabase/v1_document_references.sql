-- Burdeo Renovaciones V1
-- Metadatos documentales comunes. Los binarios permanecen en Google Drive privado.
-- NO guardar PDF/XML/fotos/base64 en PostgreSQL ni Supabase Storage para esta V1.

create extension if not exists pgcrypto;

create table if not exists public.v1_document_references (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  project_id uuid null,
  document_type text not null check (document_type in (
    'quote_pdf','approved_quote_pdf','dte_xml','invoice_pdf','payment_receipt',
    'purchase_order_pdf','design','photo','expense_receipt','project_close','other'
  )),
  drive_file_id text not null,
  drive_folder_id text null,
  filename text not null,
  mime_type text null,
  size_bytes bigint null check (size_bytes is null or size_bytes >= 0),
  sha256 text null check (sha256 is null or sha256 ~ '^[0-9a-fA-F]{64}$'),
  version integer not null default 1 check (version > 0),
  source_type text not null default 'app' check (source_type in ('app','sii','manual','generated','migration')),
  uploaded_at timestamptz not null default now(),
  uploaded_by uuid null,
  status text not null default 'active' check (status in ('active','missing','archived','replaced','error')),
  created_at timestamptz not null default now(),
  unique (organization_id, drive_file_id)
);

create index if not exists idx_v1_document_project on public.v1_document_references(organization_id, project_id, document_type);
create index if not exists idx_v1_document_hash on public.v1_document_references(organization_id, sha256) where sha256 is not null;

comment on table public.v1_document_references is
'Only metadata/references. Actual files live in private Google Drive and are accessed through authenticated backend service.';
