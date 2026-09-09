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
- Cotizador V1: familias de costo, indirectos, margen objetivo, precio sugerido, Neto/IVA/Total, margen efectivo y snapshot temporal de staging.
- Materiales V1: búsqueda/filtros, variantes por marca/espesor/color/proveedor, último costo real, referencia, costo recomendado y snapshot hacia cotización.
- PDF cliente/versionado V1 reintegrado: generación V1/V2/V3 como snapshots inmutables, vista A4 cliente, impresión/Guardar PDF desde navegador y listado de versiones.
- La vista cliente excluye costo directo, costos presupuestados, proveedores, indirectos, utilidad, margen y snapshots internos.
- En producción el PDF físico se destina a Google Drive privado; Supabase guarda datos/versiones y referencias `document_reference_id`/`drive_file_id`.
- Aprobación/línea base V1 en desarrollo: `supabase/v1_quote_approval_baseline.sql` define aprobación única, snapshot económico congelado, adicionales/órdenes de cambio y venta vigente sin reescribir la original.
- `prototype/approval-baseline-v1.js`: lógica staging aislada para congelar línea base, calcular venta vigente y crear adicionales; QA de modelo ejecutado con datos ficticios = OK.
- `Movimientos → Facturas XML`: importador DTE staging individual/múltiple, vista previa, SHA-256, detección de duplicados e historial ficticio en memoria.
- `supabase/v1_document_references.sql`: modelo documental común Drive↔Supabase sin binarios.
- `supabase/v1_dte_import.sql`: cabeceras, líneas, referencias, deduplicación y vista QA DTE.
- `supabase/v1_quoting.sql`: cabecera/partidas del cotizador, snapshots de costo y vista QA.
- `supabase/v1_material_catalog.sql`: proveedores, materiales, variantes, historial de precios y recomendación de costo.
- `supabase/v1_quote_customer_versions.sql`: snapshot comercial por versión, líneas cliente y vista QA de cuadratura/referencia Drive.
- Documentación funcional en `docs/V1_IMPORTADOR_DTE_SII.md`, `docs/V1_COTIZADOR.md`, `docs/V1_CATALOGO_MATERIALES.md`, `docs/V1_PDF_COTIZACION_CLIENTE.md` y `docs/V1_APROBACION_LINEA_BASE.md`.
- El sitio público `index.html` no fue modificado.

### Roadmap V1

1. App unificada: **EN RECONSTRUCCIÓN — shell único operativo; módulos esenciales se reintegran dentro del mismo archivo**
2. UX Yisel: **EN RECONSTRUCCIÓN — menú corto y accesos rápidos presentes**
3. Cotizador V1: **COMPLETADO PARA STAGING; persistencia productiva pendiente de bloques 16–17**
4. Materiales V1: **COMPLETADO PARA STAGING; persistencia productiva pendiente de bloques 16–17**
5. PDF cliente/versionado: **COMPLETADO PARA STAGING; integración Drive/Supabase productiva pendiente de bloques 16–17**
6. Aprobación/línea base/adicionales: **EN PROGRESO — modelo, reglas y QA lógico listos; falta interfaz integrada en `prototype/app-v1.html`**
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

- `runQuoteTests()`: valida cálculo principal del cotizador con datos ficticios.
- `runMaterialTests()`: valida recomendación de costo vigente/fallback/revisión manual.
- `runPdfTests()`: valida secuencia de versión, Neto/IVA/Total, congelamiento del snapshot y ausencia de campos internos sensibles en la versión cliente.
- `BurdeoApprovalV1.runApprovalModelTests()`: validado localmente con datos ficticios; confirma snapshot congelado, inmutabilidad de venta/costo original, adicional borrador sin impacto y adicional aprobado sumando solo a venta vigente.
- El prototipo no escribe a Supabase ni Drive productivos.

### Próxima prioridad real

Cerrar el bloque 6 integrando dentro de `prototype/app-v1.html` la selección de versión aprobada, fecha/canal/referencia, botón **Aprobar y congelar línea base**, resumen Venta original + Adicionales aprobados = Venta vigente, formulario de adicional y `runApprovalTests()` de interfaz. Después avanzar a Pagos/cobranza.

### Reglas de ejecución

- Antes de cada bloque revisar este archivo y los últimos commits de `main`.
- Datos de prueba 100% ficticios.
- No activar Supabase productivo ni recursos con costo sin autorización explícita.
- No subir documentos reales a GitHub/Vercel.
- Si un módulo avanzado de taller no es crítico para la V1, conservarlo pero no invertir tiempo en él.
