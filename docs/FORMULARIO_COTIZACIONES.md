# Formulario de cotizaciones de Burdeo — Activación

## Estado

Preparado en PR #17. NO activar la integración sin contar con el endpoint válido y una prueba de entrega al correo de Burdeo.

El sitio sigue operando en modo WhatsApp mientras `data-basin-endpoint=""` permanezca vacío en `cotizacion.html`. Esa ruta no almacena datos ni confirma que el visitante envió el WhatsApp.

## Servicio elegido

Basin (`https://usebasin.com`), compatible con GitHub Pages. Su plan gratuito anunciado en octubre de 2026 contempla 1 formulario, hasta 50 envíos por mes, 100 MB de almacenamiento para adjuntos, 30 días de historial y notificaciones por correo. Verificar límites vigentes antes de activarlo. **No se ha creado cuenta ni contratado servicio alguno.**

## Pasos que deben hacer el administrador o Yisel

1. Crear cuenta de Basin a nombre de Burdeo Renovaciones, usando una dirección que administren ustedes.
2. Crear formulario llamado **Cotizaciones Burdeo**, copiar la URL pública de envío, formato `https://usebasin.com/f/IDENTIFICADOR`.
3. Configurar notificaciones en Form > Emails para `hola@burdeorenovaciones.cl` (o correo de contacto real) y validar la cuenta/dirección según solicite Basin.
4. Configurar dominio permitido `burdeorenovaciones.cl` y protección antispam. Verificar que se admitan los adjuntos.
5. En `cotizacion.html` reemplazar `data-basin-endpoint=""` por `data-basin-endpoint="https://usebasin.com/f/IDENTIFICADOR"`. No se necesita clave privada ni se debe pegar usuario/contraseña en GitHub.
6. Probar desde móvil y PC, subiendo una fotografía pequeña y un PDF; comprobar que la solicitud figura en la bandeja y se notifica al correo. Borrar los envíos de prueba.
7. Solo después de esas pruebas, aprobar/mergear el PR a `main` para publicar por GitHub Pages.

## Comportamiento

- **Con endpoint válido:** formulario de registro con adjuntos (máximo 5 archivos, 10 MB cada uno y 25 MB total). Se transmite `multipart/form-data`, y **solo** luego de respuesta HTTP satisfactoria se muestra "Solicitud registrada" y se mide `generate_lead` en GA4 sin datos personales.
- **Sin endpoint:** se mantiene el botón de WhatsApp, se muestra que el mensaje debe enviarse dentro de WhatsApp y se mide solo `quote_whatsapp_intent`.
- **Falla de envío:** se conservan los campos completados y se ofrece WhatsApp con un mensaje precargado. Se evita presentar como recibido un envío fallido.
- **Archivos:** se almacenan en Basin y pueden estar disponibles como archivos/enlaces en bandeja o notificaciones según configuración del proveedor. No se adjuntan físicamente en el correo de forma garantizada.

## Cuidados operativos

- Monitorear uso de cuota de archivos; al llegar a 100 MB el plan gratuito puede requerir liberar almacenamiento o mejorar plan.
- El historial gratuito es de 30 días: revisar/exportar cotizaciones con frecuencia y definir una política interna de conservación.
- Mantener el consentimiento obligatorio, revisar `privacidad.html` antes de publicar y no usar material de los clientes sin su permiso.
- Revisar regularmente bandeja de entrada y spam. Confirmar que la dirección `hola@burdeorenovaciones.cl` sea un buzón real con acceso.
- No contar clics a WhatsApp como leads recibidos.
- No confiar solo en el evento GA4 para controlar las solicitudes: la bandeja de Basin es la fuente operativa de confirmación.
- Antes de cualquier campaña publicitaria, hacer una cotización de prueba con datos ficticios.

## Documentación del proveedor
- Precios: https://usebasin.com/pricing
- Notificaciones: https://docs.usebasin.com/email-notifications/notifications/
- Archivos: https://docs.usebasin.com/creating-forms/file-uploads/
- Formularios: https://docs.usebasin.com/creating-forms/form-backend/
