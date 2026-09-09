-- Burdeo Renovaciones · Catálogo de materiales V1
-- STAGING: no ejecutar en producción sin aprobación explícita.
-- Supabase almacena datos estructurados; documentos/binarios permanecen en Drive privado.

create table if not exists v1_suppliers (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  name text not null,
  tax_id text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  unique (organization_id, name)
);

create table if not exists v1_materials (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  family text not null check (family in ('Tableros','Herrajes','Cubiertas','Otros')),
  name text not null,
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists v1_material_variants (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  material_id uuid not null references v1_materials(id),
  supplier_id uuid references v1_suppliers(id),
  sku text,
  brand text,
  thickness text,
  color text,
  unit text not null default 'unidad',
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create unique index if not exists v1_material_variants_identity_uq
on v1_material_variants (
  organization_id,
  material_id,
  coalesce(supplier_id::text,''),
  lower(coalesce(brand,'')),
  lower(coalesce(thickness,'')),
  lower(coalesce(color,'')),
  lower(coalesce(unit,''))
);

create table if not exists v1_material_prices (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null,
  variant_id uuid not null references v1_material_variants(id),
  price_type text not null check (price_type in ('REAL_PURCHASE','WEB_REFERENCE','MANUAL_REFERENCE')),
  unit_cost numeric(14,2) not null check (unit_cost >= 0),
  price_date date not null,
  source_note text,
  source_document_id uuid references v1_document_references(id),
  created_at timestamptz not null default now()
);

create index if not exists v1_material_prices_variant_date_idx
on v1_material_prices (organization_id, variant_id, price_date desc);

-- Vista de recomendación V1:
-- 1) último costo real <= 60 días;
-- 2) si no, referencia más reciente entre WEB_REFERENCE y MANUAL_REFERENCE;
-- 3) si no existe, revisión manual.
create or replace view v1_material_budget_recommendation as
with grouped_prices as (
  select p.*,
    case when p.price_type = 'REAL_PURCHASE' then 'REAL' else 'REFERENCE' end as price_group
  from v1_material_prices p
), ranked as (
  select p.*,
    row_number() over (
      partition by p.organization_id,p.variant_id,p.price_group
      order by p.price_date desc,p.created_at desc
    ) rn
  from grouped_prices p
), pivoted as (
  select organization_id, variant_id,
    max(unit_cost) filter (where price_group='REAL' and rn=1) last_real_cost,
    max(price_date) filter (where price_group='REAL' and rn=1) last_real_cost_date,
    max(unit_cost) filter (where price_group='REFERENCE' and rn=1) reference_cost,
    max(price_date) filter (where price_group='REFERENCE' and rn=1) reference_date
  from ranked
  group by organization_id,variant_id
)
select v.organization_id,v.id variant_id,m.family,m.name,v.brand,v.thickness,v.color,v.unit,s.name supplier,
  p.last_real_cost,p.last_real_cost_date,p.reference_cost,p.reference_date,
  case
    when p.last_real_cost is not null and p.last_real_cost_date >= current_date - 60 then p.last_real_cost
    else p.reference_cost
  end recommended_cost,
  case
    when p.last_real_cost is not null and p.last_real_cost_date >= current_date - 60 then 'LAST_REAL_COST'
    when p.reference_cost is not null then 'REFERENCE'
    else 'MANUAL_REVIEW'
  end recommendation_source,
  case
    when p.last_real_cost is not null and p.last_real_cost_date >= current_date - 60 then p.last_real_cost_date
    else p.reference_date
  end recommendation_date
from v1_material_variants v
join v1_materials m on m.id=v.material_id
left join v1_suppliers s on s.id=v.supplier_id
left join pivoted p on p.organization_id=v.organization_id and p.variant_id=v.id
where v.active and m.active;

-- Snapshot de costo aplicado a una línea de cotización.
-- Nunca se recalcula retroactivamente al cambiar el catálogo.
alter table v1_quote_lines add column if not exists material_variant_id uuid references v1_material_variants(id);
alter table v1_quote_lines add column if not exists material_price_source text;
alter table v1_quote_lines add column if not exists material_price_date date;
alter table v1_quote_lines add column if not exists material_snapshot_unit_cost numeric(14,2);
alter table v1_quote_lines add column if not exists material_supplier_snapshot text;

create or replace view v1_material_catalog_qa as
select organization_id,
  count(*) variants,
  count(*) filter (where recommended_cost is not null) variants_with_budget_cost,
  count(*) filter (where recommendation_source='MANUAL_REVIEW') variants_needing_review
from v1_material_budget_recommendation
group by organization_id;
