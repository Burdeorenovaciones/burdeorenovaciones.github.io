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

- `prototype/app-v1.html`: app única navegable con Inicio, Proyectos, Cotizaciones, Materiales, Movimientos y Resultado.
- Cotizador V1: familias de costo, indirectos, margen objetivo, precio sugerido, Neto/IVA/Total, margen efectivo y staging local.
- Materiales V1: búsqueda/filtros, variantes, último costo real, referencia, costo recomendado y snapshot hacia cotización.
- PDF cliente/versionado V1: versiones cliente inmutables, vista A4 e impresión/Guardar PDF; el PDF productivo se destina a Drive privado.
- Aprobación/línea base/adicionales V1 integrada en `prototype/app-v1.html`: selección de versión aceptada, fecha/canal/referencia, congelamiento de venta/costo original, adicionales en borrador/aprobados y cálculo Venta original + Adicionales aprobados = Venta vigente.
- Resultado preliminar e Inicio ya consumen la venta vigente cuando existe línea base.
- `supabase/v1_quote_approval_baseline.sql`: aprobación única, snapshot económico congelado, adicionales/órdenes de cambio y venta vigente.
- `prototype/approval-baseline-v1.js`: lógica staging aislada conservada como referencia/QA.
- `Movimientos → Facturas XML`: importador DTE staging individual/múltiple, vista previa, SHA-256, detección de duplicados e historial ficticio.
- `supabase/v1_document_references.sql`: modelo documental común Drive↔Supabase sin binarios.
- `supabase/v1_dte_import.sql`: cabeceras, líneas, referencias y deduplicación DTE.
- `supabase/v1_quoting.sql`, `supabase/v1_material_catalog.sql`, `supabase/v1_quote_customer_versions.sql`: modelos staging ya preparados.
- El sitio público `index.html` no fue modificado.

### Roadmap V1

1. App unificada: **EN RECONSTRUCCIÓN — shell único operativo; módulos esenciales se reintegran en el mismo archivo**
2. UX Yisel: **EN RECONSTRUCCIÓN — menú corto y accesos rápidos presentes**
3. Cotizador V1: **COMPLETADO PARA STAGING; persistencia productiva pendiente de bloques 16–17**
4. Materiales V1: **COMPLETADO PARA STAGING; persistencia productiva pendiente de bloques 16–17**
5. PDF cliente/versionado: **COMPLETADO PARA STAGING; Drive/Supabase productivos pendientes de bloques 16–17**
6. Aprobación/línea base/adicionales: **COMPLETADO PARA STAGING; interfaz integrada y QA lógico incluido**
7. Pagos/cobranza: **PENDIENTE DE REINTEGRACIÓN — SIGUIENTE PRIORIDAD**
8. Compras/OC: **PENDIENTE DE REINTEGRACIÓN**
9. Importador XML DTE SII V1: **COMPLETADO PARA STAGING; integración productiva pendiente de bloques 16–17**
10. Imputación factura/costo: **PENDIENTE**
11. Gastos manuales: **PENDIENTE**
12. Mano de obra/equipo: **PENDIENTE**
13. Presupuesto vs real: **PENDIENTE**
14. Resultado económico: **PENDIENTE**
15. Dashboard Yisel: **PENDIENTE**
16. Google Drive privado: **MODELO DOCUMENTAL DEFINIDO; integración backend productiva pendiente**
17. Supabase/Auth/RLS: **ESQUEMAS STAGING PREPARADOS; activación productiva bloqueada por aprobación explícita**
18. QA integral: **PENDIENTE**
19. Preview Vercel: **PENDIENTE**
20. Puesta en marcha: **PENDIENTE**

### QA del bloque actual

- Validación estática de JavaScript ejecutada con `node --check` sobre el script extraído de `prototype/app-v1.html`: **OK**.
- `runQuoteTests()`: valida cálculo principal del cotizador con datos ficticios.
- `runMaterialTests()`: valida recomendación de costo vigente/fallback/revisión manual.
- `runApprovalTests()`: valida línea base congelada, adicional borrador sin efecto, adicional aprobado sumando a venta vigente e inmutabilidad de venta/costo original.
- El prototipo no escribe a Supabase ni Drive productivos.

### Próxima prioridad real

Reintegrar **Pagos/cobranza V1** dentro de `Movimientos → Pagos`: anticipo, abonos, pago final, saldo pendiente, estado financiero, referencia de comprobante privado y QA; el archivo del comprobante irá a Drive privado y Supabase conservará solo el registro financiero y referencia documental.

### Reglas de ejecución

- Antes de cada bloque revisar este archivo y los últimos commits de `main`.
- Datos de prueba 100% ficticios.
- No activar Supabase productivo ni recursos con costo sin autorización explícita.
- No subir documentos reales a GitHub/Vercel.
- Si un módulo avanzado de taller no es crítico para la V1, conservarlo pero no invertir tiempo en él.
