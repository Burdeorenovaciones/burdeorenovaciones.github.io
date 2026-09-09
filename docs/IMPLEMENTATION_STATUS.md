# Burdeo Renovaciones — Estado de Implementación

## V1 OPERATIVA

**Objetivo:** una única aplicación privada para que Yisel gestione clientes/proyectos, cotizaciones, materiales, compras, costos, pagos y rentabilidad sin planillas paralelas.

**Arquitectura obligatoria:**
- Supabase Free: datos estructurados, permisos, auditoría y referencias documentales.
- Google Drive privado: PDF, XML DTE originales, comprobantes, fotos, planos y otros binarios.
- No guardar binarios/base64/PDF/XML completos en PostgreSQL ni Supabase Storage para V1.
- Sin enlaces públicos persistentes de Drive; acceso mediado por backend autenticado.

### Estado real verificado en repositorio — 2026-09-09

La trazabilidad V1 real se mantiene en `prototype/`, `supabase/` y `docs/`. El sitio público `index.html` permanece intacto.

### Cambios verificables acumulados

- `prototype/app-v1.html`: shell único navegable con Inicio, Proyectos, Cotizaciones, Materiales, Movimientos y Resultado.
- Cotizador V1 reintegrado en la app: familias de costo, indirectos, margen objetivo, precio sugerido, Neto/IVA/Total, margen efectivo, desglose por familia y snapshot temporal de staging.
- Materiales V1 reintegrado en la app: búsqueda/filtros por familia/proveedor, variantes por marca/espesor/color, último costo real, referencia, fecha, costo recomendado y acción `Usar en cotización`.
- Las líneas seleccionadas desde Materiales conservan snapshot de variante, costo, fuente, fecha y proveedor para que una actualización futura del catálogo no reescriba la cotización.
- `Movimientos → Facturas XML`: importador DTE staging individual/múltiple, vista previa, líneas, SHA-256, detección de duplicados e historial ficticio en memoria.
- `supabase/v1_document_references.sql`: modelo documental común Drive↔Supabase sin binarios.
- `supabase/v1_dte_import.sql`: cabeceras, líneas, referencias, deduplicación y vista QA DTE.
- `supabase/v1_quoting.sql`: cabecera/partidas del cotizador, snapshots de costo y vista QA.
- `supabase/v1_material_catalog.sql`: proveedores, materiales, variantes, historial de precios, recomendación de costo y snapshot asociado a línea de cotización.
- `docs/V1_IMPORTADOR_DTE_SII.md`, `docs/V1_COTIZADOR.md` y `docs/V1_CATALOGO_MATERIALES.md`: especificaciones funcionales.
- El sitio público `index.html` no fue modificado.

### Roadmap V1

1. App unificada: **EN RECONSTRUCCIÓN — shell único operativo; módulos esenciales se reintegran dentro del mismo archivo**
2. UX Yisel: **EN RECONSTRUCCIÓN — menú corto y accesos rápidos presentes**
3. Cotizador V1: **COMPLETADO PARA STAGING; persistencia productiva pendiente de bloques 16–17**
4. Materiales V1: **COMPLETADO PARA STAGING; persistencia productiva pendiente de bloques 16–17**
5. PDF cliente/versionado: **PENDIENTE DE REINTEGRACIÓN — SIGUIENTE PRIORIDAD**
6. Aprobación/línea base/adicionales: **PENDIENTE DE REINTEGRACIÓN**
7. Pagos/cobranza: **PENDIENTE DE REINTEGRACIÓN**
8. Compras/OC: **PENDIENTE DE REINTEGRACIÓN**
9. Importador XML DTE SII V1: **COMPLETADO PARA STAGING; integración productiva pendiente de bloques 16–17**
10. Imputación factura/costo: **PENDIENTE**
11. Gastos manuales: **PENDIENTE**
12. Mano de obra/equipo: **PENDIENTE**
13. Presupuesto vs real: **PENDIENTE**
14. Resultado económico: **PENDIENTE**
15. Dashboard Yisel: **PENDIENTE**
16. Google Drive privado: **MODELO DOCUMENTAL DEFINIDO; integración backend productiva pendiente**
17. Supabase/Auth/RLS: **ESQUEMAS STAGING PREPARADOS; activación productiva bloqueada por aprobación**
18. QA integral: **PENDIENTE**
19. Preview Vercel: **PENDIENTE**
20. Puesta en marcha: **PENDIENTE**

### QA del bloque actual

- `runQuoteTests()`: valida costo directo, indirectos, costo total, precio sugerido, IVA, Total cliente y margen efectivo con datos ficticios.
- `runMaterialTests()`: valida costo real reciente, fallback a referencia cuando el real está vencido, referencia sin costo real, revisión manual y snapshot de precio al incorporar una variante al cotizador.
- El esquema SQL fue ajustado para elegir la referencia más reciente entre `WEB_REFERENCE` y `MANUAL_REFERENCE`, evitando seleccionar un valor por monto cuando existan ambas fuentes.
- El prototipo no escribe a Supabase ni Drive productivos.

### Próxima prioridad real

Reintegrar **PDF cliente/versionado V1** en `prototype/app-v1.html`: vista cliente sin costos/márgenes internos, versiones inmutables y preparación para que el PDF físico quede en Google Drive privado mientras Supabase conserva la versión y `drive_file_id`.

### Reglas de ejecución

- Antes de cada bloque revisar este archivo y los últimos commits de `main`.
- Datos de prueba 100% ficticios.
- No activar Supabase productivo ni recursos con costo sin autorización explícita.
- No subir documentos reales a GitHub/Vercel.
- Si un módulo avanzado de taller no es crítico para la V1, conservarlo pero no invertir tiempo en él.
