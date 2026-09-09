# V1 Pagos y cobranza

## Estado

**EN PROGRESO — lógica y esquema staging listos; integración visual en `prototype/app-v1.html` pendiente.**

## Objetivo funcional

Yisel debe poder registrar anticipo, abonos, pago final u otro pago contra la **venta vigente** del proyecto, ver total cobrado, saldo pendiente y estado de cobranza, y mantener historial reversible sin borrar registros.

## Campos V1

- Proyecto.
- Tipo: anticipo, abono, pago final u otro.
- Fecha.
- Monto.
- Medio de pago.
- Referencia externa opcional.
- Nota opcional.
- Referencia documental del comprobante.
- Estado: confirmado o reversado.

## Arquitectura documental

El comprobante original (PDF, imagen u otro archivo) debe almacenarse exclusivamente en **Google Drive privado**. Supabase conserva el registro financiero y `receipt_document_id`, que referencia `v1_document_references`. No se guardan binarios, base64 ni URLs públicas persistentes.

## Reglas económicas

- Solo pagos `CONFIRMADO` suman a cobrado.
- Un pago reversado permanece en historial, pero deja de afectar cobranza.
- `saldo pendiente = max(0, venta vigente - cobrado)`.
- Estados de cobranza staging: `SIN_PAGOS`, `PARCIAL`, `PAGADO`, `SOBREPAGO`.
- Los adicionales aprobados aumentan la venta vigente antes de calcular el saldo.

## QA ejecutado

`prototype/payments-v1.js` expone `runPaymentTests()` y valida con datos ficticios:

1. anticipo + abono suman correctamente;
2. saldo parcial se calcula contra venta vigente;
3. reversa elimina el efecto financiero sin eliminar el registro;
4. pago final puede cerrar saldo;
5. el objeto de pago queda congelado en staging;
6. la referencia documental del comprobante se conserva separada del archivo.

Validación ejecutada con `node --check` y `runPaymentTests()`: **OK**.

## Pendiente para cerrar el bloque 7

Insertar en `Movimientos → Pagos` el formulario y resumen visual, conectar sus cálculos con `currentNetSale()` y `Resultado`, mostrar historial/reversa y agregar `runPaymentTests()` al QA integrado de `app-v1.html`. Hasta completar esto, el bloque no debe marcarse como terminado.
