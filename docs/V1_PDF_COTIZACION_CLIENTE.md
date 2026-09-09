# V1 — PDF de cotización cliente y versionado

## Objetivo
Permitir que Yisel emita desde la app una versión comercial de la cotización lista para entregar al cliente, sin exponer costos, proveedores, indirectos, utilidad ni margen.

## Flujo V1
1. La cotización interna calcula costos y precio cliente.
2. `Generar versión cliente` crea un snapshot comercial independiente.
3. Cada emisión aumenta la versión V1, V2, V3, etc.; una versión emitida no se reescribe.
4. La vista cliente muestra proyecto, cliente, fecha, vigencia, alcance, partidas comerciales, Neto, IVA, Total y condiciones.
5. En staging, `Imprimir / Guardar PDF` usa la impresión del navegador.
6. En producción, el backend generará/recibirá el PDF y lo guardará en Google Drive privado. Supabase conservará solo datos estructurados, versión y referencias documentales/`drive_file_id`.

## Privacidad
La representación cliente no contiene:
- costo directo ni costo presupuestado;
- indirectos;
- margen objetivo o efectivo;
- utilidad;
- proveedor o costo de proveedor;
- snapshots internos de precios/materiales.

No se guardan PDF/base64/binarios en PostgreSQL ni Supabase Storage para esta V1.

## Esquema
`supabase/v1_quote_customer_versions.sql` define:
- `v1_quote_customer_versions`: snapshot de cabecera y totales por versión;
- `v1_quote_customer_version_lines`: líneas comerciales del documento;
- `v1_quote_customer_versions_qa`: control de cuadratura y referencia Drive.

La unicidad `(organization_id, quote_id, version)` impide repetir una versión. Las correcciones deben generar una versión nueva.

## QA staging
`runPdfTests()` valida con datos ficticios:
- secuencia de versión;
- Neto + IVA = Total;
- snapshot congelado en memoria;
- ausencia de campos internos sensibles en el snapshot comercial;
- líneas comerciales separadas de costos internos.

## Pendiente productivo
- autenticación y RLS;
- persistencia real Supabase;
- servicio backend para generar/subir PDF a Drive privado;
- guardar `document_reference_id` y `drive_file_id` después de la subida;
- manejo de error si Drive no responde o el archivo se elimina.
