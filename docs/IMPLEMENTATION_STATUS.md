# Burdeo Renovaciones — Estado de Implementación

## V1 OPERATIVA

**Objetivo:** una única aplicación privada para que Yisel gestione clientes/proyectos, cotizaciones, materiales, compras, costos, pagos y rentabilidad sin planillas paralelas.

**Arquitectura obligatoria:**
- Supabase Free: datos estructurados, permisos, auditoría y referencias documentales.
- Google Drive privado: PDF, XML DTE originales, comprobantes, fotos, planos y otros binarios.
- No guardar binarios/base64/PDF/XML completos en PostgreSQL ni Supabase Storage para V1.
- Sin enlaces públicos persistentes de Drive; acceso mediado por backend autenticado.

### Estado real verificado en repositorio — 2026-09-09

Al iniciar esta ejecución, `main` no contenía los archivos V1 ni los commits previamente reportados por ejecuciones anteriores. El sitio público existente se mantuvo intacto. Se reinició la trazabilidad V1 en rutas nuevas (`prototype/`, `supabase/`, `docs/`) para no modificar producción ni repetir afirmaciones no verificables.

### Cambios verificables de esta ejecución

- `prototype/app-v1.html`: shell único navegable V1 con Inicio, Proyectos, Cotizaciones, Materiales, Movimientos y Resultado.
- `Movimientos → Facturas XML`: importador DTE staging individual/múltiple, vista previa, líneas, SHA-256, detección de duplicados e historial ficticio en memoria.
- `supabase/v1_document_references.sql`: modelo documental común Drive↔Supabase sin binarios.
- `supabase/v1_dte_import.sql`: cabeceras, líneas, referencias, deduplicación y vista QA del DTE estructurado.
- `docs/V1_IMPORTADOR_DTE_SII.md`: especificación funcional y pendientes productivos.
- El sitio público `index.html` no fue modificado.

### Roadmap V1

1. App unificada: **EN RECONSTRUCCIÓN — shell único ya creado**
2. UX Yisel: **EN RECONSTRUCCIÓN — menú corto y accesos rápidos ya presentes**
3. Cotizador V1: **PENDIENTE DE REINTEGRACIÓN**
4. Materiales V1: **PENDIENTE DE REINTEGRACIÓN**
5. PDF cliente/versionado: **PENDIENTE DE REINTEGRACIÓN**
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
17. Supabase/Auth/RLS: **ESQUEMA DTE/DOCUMENTOS PREPARADO; activación productiva bloqueada por aprobación**
18. QA integral: **PENDIENTE**
19. Preview Vercel: **PENDIENTE**
20. Puesta en marcha: **PENDIENTE**

### Próxima prioridad real

Debido a que los módulos 1–8 previamente reportados no estaban presentes en el repositorio conectado, la siguiente ejecución debe continuar reconstruyendo la V1 dentro de `prototype/app-v1.html` empezando por los componentes esenciales faltantes, sin avanzar a funciones de taller ni publicar producción.

### Reglas de ejecución

- Antes de cada bloque revisar este archivo y los últimos commits de `main`.
- Datos de prueba 100% ficticios.
- No activar Supabase productivo ni recursos con costo sin autorización explícita.
- No subir documentos reales a GitHub/Vercel.
- Si un módulo avanzado de taller no es crítico para la V1, conservarlo pero no invertir tiempo en él.
