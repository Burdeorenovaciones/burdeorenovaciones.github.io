# V1 — Importador XML DTE SII

## Objetivo
Permitir que Yisel revise e importe DTE individuales o respaldos con múltiples nodos `Documento`, usando solo datos ficticios en staging.

## Arquitectura
- **Google Drive privado:** XML original y PDF relacionado cuando exista.
- **Supabase:** cabecera DTE, líneas, referencias, SHA-256, estado y `original_document_id` hacia `v1_document_references`.
- No guardar XML completo, PDF, fotografía, base64 ni binarios en PostgreSQL/Supabase Storage para esta V1.
- No usar enlaces `Anyone with the link` ni exponer credenciales Google en navegador.

## Datos estructurados mínimos
- RUT receptor/organización
- RUT emisor y razón social
- TipoDTE
- Folio
- fecha de emisión
- Neto
- IVA
- Exento
- Total
- líneas de detalle
- referencias DTE cuando correspondan
- SHA-256 del XML
- referencia al archivo privado en Drive

## Deduplicación
Se aplican dos barreras:
1. `organization_id + recipient_rut + issuer_rut + dte_type + folio`
2. `organization_id + xml_sha256`

En la UI staging, el mismo criterio se simula en memoria antes de registrar.

## Flujo de interfaz implementado
`Movimientos → Facturas XML`:
1. seleccionar XML ficticio o cargar el ejemplo incorporado;
2. parsear uno o varios `Documento`;
3. mostrar proveedor, TipoDTE, folio, fecha, Neto/IVA/Exento/Total y líneas;
4. calcular SHA-256 con Web Crypto;
5. advertir posibles duplicados;
6. permitir registrar solo en memoria de staging;
7. mostrar historial ficticio de la sesión.

## QA incorporado
`runDteTests()` valida al cargar la página:
- disponibilidad de DOMParser;
- presencia de TipoDTE 33 en el ejemplo ficticio;
- ausencia de URL pública en el XML demo;
- declaración visible de almacenamiento original en Drive privado;
- declaración visible de datos estructurados en Supabase.

## Pendiente para producción
- Backend autenticado para subir el XML a Drive y devolver IDs privados.
- Persistencia real en Supabase después de subir exitosamente a Drive.
- RLS/Auth y roles.
- Manejo transaccional de error parcial Drive/Supabase.
- Pruebas con XML reales solo en entorno privado, nunca GitHub/Vercel.

## Estado
**COMPLETADO PARA STAGING V1** en esta ejecución. No equivale a integración productiva ni autoriza activar Supabase/Drive productivo.
