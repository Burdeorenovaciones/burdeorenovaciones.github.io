# Cotizador V1 — Burdeo Renovaciones

## Estado

Reintegrado en `prototype/app-v1.html` dentro de la aplicación unificada de Yisel.

## Alcance V1

El cotizador permite trabajar en una sola pantalla con:

- muebles/partidas;
- materiales;
- herrajes;
- mano de obra;
- instalación;
- transporte/flete;
- alimentación y otros gastos directos;
- subcontratos y otros costos directos;
- indirectos configurables como porcentaje del costo directo;
- margen objetivo;
- Neto, IVA y Total cliente;
- precio neto sugerido calculado por margen;
- precio neto manual con alerta si cae bajo el margen objetivo;
- desglose de costo por familia.

## Regla económica

`precio_neto_sugerido = costo_presupuestado / (1 - margen_objetivo)`

El margen efectivo se calcula sobre la venta neta:

`margen_efectivo = (venta_neta - costo_presupuestado) / venta_neta`

## Persistencia

En staging el prototipo guarda un snapshot temporal en `sessionStorage` solo para demostrar el flujo.

En producción:

- cabecera, partidas, costos, margen y cálculos: Supabase;
- PDF emitido: Google Drive privado;
- referencia del PDF: `v1_document_references` + `customer_pdf_document_id`;
- ningún PDF, XML, binario o base64 debe almacenarse en PostgreSQL.

## QA incluido

`runQuoteTests()` valida con datos ficticios:

1. suma de costo directo;
2. cálculo de indirectos;
3. costo presupuestado total;
4. precio neto sugerido;
5. IVA;
6. Total cliente;
7. margen efectivo.

## Pendientes relacionados

- Bloque 4: catálogo de materiales y snapshots de costo de referencia.
- Bloque 5: PDF cliente definitivo/versionado en Drive privado.
- Bloque 6: aprobación y congelamiento de línea base.
- Bloques 13–14: presupuesto vs real y resultado económico final.
