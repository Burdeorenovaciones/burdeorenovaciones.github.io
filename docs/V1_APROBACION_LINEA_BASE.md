# V1 — Aprobación, línea base y adicionales

## Objetivo

Convertir una versión cliente emitida en la referencia económica inmutable del proyecto. Una vez aprobada, la cotización original no se reescribe: cualquier cambio posterior se registra como adicional u orden de cambio independiente.

## Flujo de Yisel

1. Generar una versión cliente V1/V2/V3 desde la cotización.
2. Cuando el cliente acepte una versión, registrar fecha, canal y referencia de aprobación.
3. Congelar esa versión como **línea base**.
4. Mantener visibles por separado:
   - venta original aprobada;
   - costo presupuestado original;
   - margen esperado original.
5. Si el cliente solicita un cambio posterior, crear un **Adicional / Orden de cambio**.
6. El adicional puede estar Borrador, Enviado, Aprobado, Rechazado o Anulado.
7. Solo los adicionales **Aprobados** modifican la venta vigente y el presupuesto vigente.
8. La venta original nunca cambia.

## Snapshot de línea base

Al aprobar se congelan dos vistas:

### Comercial
- versión cliente aprobada;
- Neto;
- IVA;
- Total;
- partidas comerciales;
- condiciones;
- vigencia y observaciones.

### Interna
- partidas y cantidades presupuestadas;
- costos unitarios utilizados;
- snapshots de materiales;
- costo directo;
- indirectos;
- costo presupuestado total;
- margen objetivo;
- margen esperado.

Estos snapshots sirven para comparar posteriormente presupuesto vs real sin perder la referencia original.

## Adicionales / órdenes de cambio

Cada orden de cambio contiene como mínimo:
- proyecto y línea base;
- número correlativo;
- título y descripción;
- partidas;
- Neto/IVA/Total adicional;
- costo incremental presupuestado;
- margen esperado del cambio;
- estado;
- fecha/canal/referencia de aprobación cuando corresponda.

Regla económica:

`Venta vigente = Venta original + adicionales aprobados`

Los adicionales en borrador, enviados, rechazados o anulados no incrementan la venta vigente.

## Arquitectura documental

Supabase conserva datos estructurados, estados, snapshots económicos y referencias documentales.

Google Drive privado conserva:
- PDF de la versión cliente aprobada;
- correo/comprobante/archivo de aceptación si existe;
- PDF de cada orden de cambio cuando se emita;
- respaldo de aprobación del adicional cuando exista.

La base solo referencia esos documentos mediante `document_reference_id` / `drive_file_id`. No se almacenan PDF, imágenes o base64 en PostgreSQL.

## Esquema staging

Archivo: `supabase/v1_quote_approval_baseline.sql`

Tablas:
- `v1_quote_approvals`
- `v1_quote_baselines`
- `v1_change_orders`
- `v1_change_order_lines`

Vistas:
- `v1_project_sales_current`
- `v1_quote_baseline_qa`

## Reglas de integridad

- una cotización tiene una única línea base aprobada V1;
- la línea base se crea desde una versión cliente ya emitida;
- Neto + IVA = Total;
- costo directo + indirectos = costo presupuestado;
- no se modifica la línea base para incorporar cambios;
- los cambios posteriores se registran exclusivamente como órdenes de cambio;
- solo órdenes aprobadas impactan venta vigente.

## QA esperado en la app

`runApprovalTests()` debe validar al menos:
1. una versión emitida puede convertirse en línea base;
2. venta original coincide con la versión aprobada;
3. costo original coincide con el presupuesto congelado;
4. después de aprobación, editar la cotización no altera la línea base;
5. adicional en borrador no cambia venta vigente;
6. adicional aprobado sí incrementa venta vigente;
7. venta original permanece idéntica después del adicional.

## Estado

**EN PROGRESO PARA STAGING.** El modelo relacional y las reglas funcionales están definidos. Falta reintegrar la interfaz y `runApprovalTests()` dentro de `prototype/app-v1.html` para cerrar el bloque 6.