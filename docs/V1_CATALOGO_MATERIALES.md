# Catálogo de Materiales V1 — Burdeo Renovaciones

## Objetivo

Dar a Yisel una referencia simple y trazable para presupuestar materiales y herrajes sin depender de una planilla paralela.

## Alcance V1

Cada variante puede identificar:
- familia;
- material;
- proveedor;
- marca;
- espesor o medida;
- color;
- unidad;
- último costo real y fecha;
- precio web/manual de referencia y fecha;
- costo recomendado para presupuestar.

## Regla de costo recomendado

1. Si existe un último costo real con antigüedad máxima de 60 días, se usa ese costo.
2. En caso contrario se usa la referencia más reciente disponible entre precio web y referencia manual.
3. Si no existe ninguno de los anteriores, la variante queda como `MANUAL_REVIEW` y no debe agregarse automáticamente al cotizador.

La regla es una ayuda operativa, no reemplaza la revisión de Yisel cuando exista una condición comercial especial.

## Integración con cotización

Al seleccionar `Usar en cotización`, la línea conserva un snapshot independiente del catálogo:
- `material_variant_id`;
- costo unitario utilizado;
- fuente del precio;
- fecha del precio;
- proveedor utilizado como referencia.

Una actualización posterior del catálogo no modifica retroactivamente una cotización ya preparada.

## Persistencia

Supabase Free será el origen de verdad de los datos estructurados mediante:
- `v1_suppliers`;
- `v1_materials`;
- `v1_material_variants`;
- `v1_material_prices`;
- `v1_material_budget_recommendation`.

Cuando un precio real tenga respaldo documental, Supabase conserva únicamente `source_document_id`. El documento original correspondiente permanece en Google Drive privado mediante `v1_document_references`.

No se almacenan archivos, fotografías, PDF, XML ni base64 en estas tablas.

## Datos de staging

`prototype/app-v1.html` contiene únicamente variantes y precios ficticios para validar el flujo. No representan precios comerciales reales de Burdeo Renovaciones.

## QA V1

`runMaterialTests()` valida con datos ficticios:
- priorización de costo real reciente;
- descarte de costo real vencido y uso de referencia;
- variante con solo referencia;
- variante que requiere revisión manual;
- creación del snapshot de precio al usar una variante en cotización.

Además, `v1_material_catalog_qa` permite contar variantes con costo recomendado y variantes pendientes de revisión cuando el esquema se implemente en Supabase.

## Pendiente productivo

La conexión real a Supabase, autenticación, RLS y carga de proveedores/precios reales queda para el bloque 17 y requiere aprobación explícita antes de activar infraestructura productiva.
