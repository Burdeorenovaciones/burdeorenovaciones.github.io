(() => {
  'use strict';
  const form = document.getElementById('quoteForm');
  if (!form) return;

  const el = id => document.getElementById(id);
  const endpoint = (form.dataset.basinEndpoint || '').trim();
  const backendActivo = /^https:\/\/usebasin\.com\/f\/[\w-]+\/?$/.test(endpoint);
  const boton = el('botonCotizar');
  const tituloBoton = el('textoCotizar');
  const error = el('errorEnvio');
  const estadoWhatsapp = el('envioEstado');
  const enlaceWhatsapp = el('abrirWhatsApp');
  const confirmacion = el('cotizacionConfirmada');
  const entradaArchivos = el('archivos');

  if (backendActivo) {
    el('adjuntosBasin').hidden = false;
    entradaArchivos.disabled = false;
    el('notaAdjuntosWhatsApp').hidden = true;
    tituloBoton.textContent = 'Enviar solicitud de cotización';
    el('iconoCotizar').className = 'fas fa-paper-plane';
    el('introCotizacion').textContent = 'Cuéntanos qué necesitas y adjunta fotografías o planos si los tienes. Tu consulta quedará registrada para que Burdeo pueda responderte.';
    el('notaEnvio').textContent = 'Al enviar, verás una confirmación cuando el sistema registre tu consulta. También puedes escribirnos por WhatsApp.';
  }

  form.querySelectorAll('input, textarea').forEach(campo =>
    campo.addEventListener('input', () => campo.setCustomValidity(''))
  );

  const leerDatos = () => ({
    nombre: el('nombre').value.trim(),
    telefono: el('telefono').value.trim(),
    email: el('email').value.trim(),
    ciudad: el('ciudad').value.trim(),
    tipo: el('tipo').value,
    medidas: el('medidas').value.trim() || 'No indicadas',
    presupuesto: el('presupuesto').value || 'Por definir',
    mensaje: el('mensaje').value.trim()
  });

  const crearWhatsApp = d => {
    const texto = [
      'Hola, Burdeo Renovaciones. Quiero solicitar una cotización:',
      '', 'Proyecto: ' + d.tipo, 'Nombre: ' + d.nombre,
      'WhatsApp: ' + d.telefono,
      d.email ? 'Correo: ' + d.email : '',
      'Ciudad/comuna: ' + d.ciudad,
      'Medidas aproximadas: ' + d.medidas,
      'Presupuesto: ' + d.presupuesto,
      '', 'Detalles:', d.mensaje
    ].filter(Boolean).join('\n');
    return 'https://wa.me/56967797864?text=' + encodeURIComponent(texto);
  };

  const comprobarArchivos = () => {
    const archivos = Array.from(entradaArchivos.files || []);
    if (archivos.length > 5) return 'Puedes adjuntar hasta 5 archivos.';
    if (archivos.some(f => !/\.(jpe?g|png|webp|heic|heif|pdf)$/i.test(f.name) || f.size > 10 * 1024 * 1024))
      return 'Adjunta imágenes o PDF de máximo 10 MB por archivo.';
    if (archivos.reduce((total, f) => total + f.size, 0) > 25 * 1024 * 1024)
      return 'Los archivos no pueden superar 25 MB en total.';
    return '';
  };

  form.addEventListener('submit', async evento => {
    evento.preventDefault();
    error.hidden = true;
    error.textContent = '';
    estadoWhatsapp.hidden = true;

    if (!form.checkValidity()) {
      form.reportValidity();
      return;
    }
    for (const id of ['nombre', 'telefono', 'ciudad', 'mensaje']) {
      const campo = el(id);
      if (!campo.value.trim()) {
        campo.setCustomValidity('Completa este campo con información válida.');
        campo.reportValidity();
        return;
      }
    }

    const datos = leerDatos();
    const urlWhatsApp = crearWhatsApp(datos);

    if (!backendActivo) {
      enlaceWhatsapp.href = urlWhatsApp;
      estadoWhatsapp.hidden = false;
      if (typeof gtag === 'function')
        gtag('event', 'quote_whatsapp_intent', {form_name:'cotizacion_burdeo', project_type:datos.tipo});
      const ventana = window.open(urlWhatsApp, '_blank');
      if (ventana) ventana.opener = null;
      estadoWhatsapp.scrollIntoView({behavior:'smooth', block:'nearest'});
      return;
    }

    const errorArchivos = comprobarArchivos();
    if (errorArchivos) {
      error.textContent = errorArchivos;
      error.hidden = false;
      error.scrollIntoView({behavior:'smooth', block:'nearest'});
      return;
    }

    boton.disabled = true;
    tituloBoton.textContent = 'Enviando solicitud…';
    const datosFormulario = new FormData(form);
    datosFormulario.delete('attachments[]');
    Array.from(entradaArchivos.files || []).forEach(f => datosFormulario.append('attachments[]', f, f.name));
    datosFormulario.set('origen', 'web_burdeo');

    const query = new URLSearchParams(window.location.search);
    ['utm_source', 'utm_medium', 'utm_campaign'].forEach(campo => {
      const valor = (query.get(campo) || '').slice(0, 80);
      if (valor) datosFormulario.set(campo, valor);
    });

    try {
      const respuesta = await fetch(endpoint, {
        method: 'POST',
        body: datosFormulario,
        headers: {Accept: 'application/json'}
      });
      if (!respuesta.ok) throw new Error('Basin no confirmó la recepción');
      form.hidden = true;
      confirmacion.hidden = false;
      confirmacion.scrollIntoView({behavior:'smooth', block:'center'});
      if (typeof gtag === 'function')
        gtag('event', 'generate_lead', {form_name:'cotizacion_burdeo', project_type:datos.tipo});
    } catch (_) {
      error.textContent = 'No pudimos registrar tu solicitud. Puedes reintentar sin perder los datos o ';
      const enlace = document.createElement('a');
      enlace.href = urlWhatsApp;
      enlace.target = '_blank';
      enlace.rel = 'noopener noreferrer';
      enlace.textContent = 'contactarnos por WhatsApp';
      error.appendChild(enlace);
      error.appendChild(document.createTextNode('.'));
      error.hidden = false;
      error.scrollIntoView({behavior:'smooth', block:'nearest'});
    } finally {
      boton.disabled = false;
      tituloBoton.textContent = 'Enviar solicitud de cotización';
    }
  });
})();