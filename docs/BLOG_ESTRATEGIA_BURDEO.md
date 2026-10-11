# Blog Burdeo Renovaciones — propuesta editorial para revisión

Estado: BORRADOR, no publicado. No fusionar antes de revisar visualmente en escritorio y móvil.

## Enfoque

Mantener intacta la identidad visual del sitio: logo, tipografía, navegación, íconos de redes, pie de página y botón WhatsApp. Publicar un blog con contenido que ayude al cliente y documente obras reales. La ciudad forma parte del relato cuando corresponde, **no** se crea una página repetida por cada ubicación.

## Arquitectura propuesta

- `/blog/`: portada «Espacios que cuentan historias».
- `/blog/casa-katya-cocina-con-isla-puerto-varas.html`: primer artículo piloto sobre el proyecto Casa Katya.
- Cada entrada: proyecto/fuente real, fotos verificadas, título SEO único, lugar real, consejo útil, enlace a galería y botón a cotización por WhatsApp.
- Usar esquema Blog y BlogPosting, títulos/canonical individuales y enlaces internos a los servicios.
- Agregar «Blog» a la navegación del sitio y al sitemap **solo cuando se apruebe publicar**.

## Pilares de contenido (no todos publicados)

1. **Proyectos reales:** contexto y decisiones de diseño basados en los detalles realmente documentados. Casa Katya (Puerto Varas), Departamento PV, cocina del Edificio Puerto Montt, baño Valle Volcanes, quinchos Alerce, etc.
2. **Educación:** cómo tomar medidas, cuándo una isla es apropiada, qué datos enviar para cotizar, cómo seleccionar herrajes, consejos sobre mantenimiento.
3. **Materiales:** comparación explicativa de melamina/enchapados/cubiertas basada en fichas técnicas y proveedores, sin atribuir materiales no confirmados a proyectos concretos.
4. **Procesos:** levantamiento, diseño, dimensionado, fabricación, instalación, explicando tiempos como orientativos y dependientes del alcance.

## Propuesta de publicaciones (dos por mes inicialmente)

- Mes 1: Casa Katya — cocina con isla en Puerto Varas (piloto).
- Mes 1: Cómo preparar fotografías y medidas para cotizar una cocina a medida.
- Mes 2: Departamento PV — almacenamiento en cocina pequeña.
- Mes 2: Qué considerar para planificar una remodelación de baño.
- Mes 3: Casa del Lago — inspiración desde Frutillar, basado en evidencia real.
- Mes 3: Organización de clósets: medidas, usos y herrajes.

## SEO geográfico sin páginas duplicadas

- Usar ciudad y región de una **obra ejecutada** en título, descripción y cuerpo solo si es verificable.
- Puerto Montt = base de atención, Puerto Varas/Frutillar/Los Muermos = proyectos publicados.
- Osorno, Lago Rupanco y Los Ríos = consultas según evaluación de logística y factibilidad, no afirmar proyectos realizados ni sucursales sin prueba.
- No publicar entradas cuyo único contenido sea repetir palabras clave de localidades.
- Cada artículo enlaza a su galería real y al formulario con WhatsApp.

## Criterios para aprobar lanzamiento

1. Encabezado, redes sociales circulares, logo y footer muestran la misma identidad que la portada actual.
2. Menú móvil se abre/cierra; no muestra viñetas en escritorio; iconos y fuentes cargan.
3. Fotografías visibles, recortes adecuados, textos legibles en celular, tablet y escritorio.
4. Clics a proyectos reales y WhatsApp funcionan sin inventar confirmación de cotización.
5. JSON-LD validado, H1 único, canonical correcto; enlaces y fotografías existentes.
6. Agregar al inicio una sección editorial moderada, navegación Blog y sitemap **después de aprobación**, manteniendo la web principal intacta hasta entonces.

## Material ya preparado

- `blog/index.html`: portada editorial en borrador.
- `blog/casa-katya-cocina-con-isla-puerto-varas.html`: artículo 1 con detalles basados en `cocinas/proyecto-katya.html` y `cocinas/proyecto-katya-2.html`.

Esta rama no incluye cambios a `main` ni al formulario de cotizaciones.
