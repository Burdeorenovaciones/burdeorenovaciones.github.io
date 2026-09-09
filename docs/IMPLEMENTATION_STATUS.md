# Burdeo Renovaciones — Estado de Implementación

## V1 OPERATIVA

**Objetivo:** una única aplicación privada para que Yisel gestione clientes/proyectos, cotizaciones, materiales, compras, costos, pagos y rentabilidad sin planillas paralelas.

**Arquitectura obligatoria:**
- Supabase Free: datos estructurados, permisos, auditoría y referencias documentales.
- Google Drive privado: PDF, XML DTE originales, comprobantes, fotos, planos y otros binarios.
- No guardar binarios/base64/PDF/XML completos en PostgreSQL ni Supabase Storage para V1.
- Sin enlaces públicos persistentes de Drive; acceso mediado por backend autenticado.

### Estado real verificado en repositorio — 2026-09-09

Al iniciar esta ejecución, `main` no contenía los archivos V1 ni los commits previamente reportados por ejecuciones anteriores. El sitio público existente se mantiene intacto. Se reinicia la trazabilidad V1 en rutas nuevas (`prototype/`, `supabase/`, `docs/`) para no modificar producción ni repetir afirmaciones no verificables.

### Roadmap V1

1. App unificada: **EN RECONSTRUCCIÓN / shell creado en esta ejecución**
2. UX Yisel: **EN RECONSTRUCCIÓN**
3. Cotizador V1: **PENDIENTE DE REINTEGRACIÓN**
4. Materiales V1: **PENDIENTE DE REINTEGRACIÓN**
5. PDF cliente/versionado: **PENDIENTE DE REINTEGRACIÓN**
6. Aprobación/línea base/adicionales: **PENDIENTE DE REINTEGRACIÓN**
7. Pagos/cobranza: **PENDIENTE DE REINTEGRACIÓN**
8. Compras/OC: **PENDIENTE DE REINTEGRACIÓN**
9. Importador XML DTE SII V1: **EN PROGRESO — prioridad actual**
10. Imputación factura/costo: **PENDIENTE**
11. Gastos manuales: **PENDIENTE**
12. Mano de obra/equipo: **PENDIENTE**
13. Presupuesto vs real: **PENDIENTE**
14. Resultado económico: **PENDIENTE**
15. Dashboard Yisel: **PENDIENTE**
16. Google Drive privado: **DISEÑO TRANSVERSAL DESDE AHORA; integración productiva pendiente**
17. Supabase/Auth/RLS: **DISEÑO TRANSVERSAL DESDE AHORA; activación productiva bloqueada por aprobación**
18. QA integral: **PENDIENTE**
19. Preview Vercel: **PENDIENTE**
20. Puesta en marcha: **PENDIENTE**

### Reglas de ejecución

- Antes de cada bloque revisar este archivo y los últimos commits de `main`.
- Datos de prueba 100% ficticios.
- No activar Supabase productivo ni recursos con costo sin autorización explícita.
- No subir documentos reales a GitHub/Vercel.
- Si un módulo avanzado de taller no es crítico para la V1, conservarlo pero no invertir tiempo en él.
