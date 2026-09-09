# Auditoría de proyectos — Burdeo Renovaciones

Rama de trabajo: `mejora-web-seo-2026`

## 1. Proyectos que YA tienen página en la web

### Cocinas
- Proyecto William — Puerta Sur — `cocinas/proyecto-william.html`
- Proyecto Luigi — Puerta Sur — `cocinas/proyecto-luigi.html`
- Casa Katya 1 — Puerto Varas — `cocinas/proyecto-katya.html`
- Casa Katya 2 — Puerto Varas — `cocinas/proyecto-katya-2.html`
- Proyecto Chacana — Los Muermos — `cocinas/proyecto-chacana.html`
- Proyecto FT — Alerce — `cocinas/proyecto-ft.html`
- Proyecto Frutillar — `cocinas/proyecto-frutillar.html`
- Departamentos Puerto Varas — `cocinas/proyecto-deptos-pv.html`
- Proyecto Departamento Puerto Montt (Katherine) — `cocinas/proyecto-depto-puerto-montt.html` — **nuevo en rama**
- Proyecto Puerta Sur — `cocinas/proyecto-puerta-sur.html` — **nuevo en rama**

### Quinchos
- Quincho FT — Alerce — `quinchos/ft-alerce.html`
- Quincho Sol de Oriente — Puerto Montt — `quinchos/soldeoriente.html`

## 2. Coincidencias confirmadas en Google Drive de proyectos ya publicados

- William: carpetas `1. Cocina Wiliam` y `Casa Wiliam PTA SUR`.
- Luigi: carpetas `Cocina Luigis OK` y `Luigis Gomez`.
- Katya: carpetas `2. Casa Katya 1` y `10.Casa Katya 2`.
- Chacana: carpeta `3.Chacana-Muermos`.
- FT: carpetas `1. Casa FToledo` y `FT Quincho`.

Estas coincidencias se consideran proyectos existentes; no se crearán duplicados. Si Drive contiene fotografías mejores o posteriores, se evaluarán como ampliación de las galerías actuales.

## 3. Proyectos y carpetas detectados en Drive

### Incorporados en la rama
- **Depto Katherine Chávez — Puerto Montt.** Fotografías finales, diseño y proceso revisados. Página y carpeta creadas.
- **Casa Muricio / Mauricio — Puerta Sur.** Se encontró una subcarpeta WebP preparada en Drive; se seleccionaron y verificaron portada, vista general y detalle. Página `proyecto-puerta-sur.html` creada.

### Pendientes — prioridad Puerto Montt
- **Depto Fabian — Puerto Montt.** Se revisaron visualmente los HEIC. `IMG_3005`, `IMG_3006` e `IMG_3007` muestran el resultado final y son las mejores candidatas para publicación; `IMG_2999`, `IMG_3001` e `IMG_3004` sirven como proceso/detalle. Las conversiones WebP fueron validadas localmente. **No crear página ni referenciar imágenes hasta completar y verificar su carga binaria en GitHub.**
- **`9. Depto 1602 - PTO MONTT`.** La carpeta funciona como contenedor y dentro de ella aparecen `Depto Katherine Chavez`, `Fotos Carlos`, `Katerin Chavez` y una planilla `Dpto 1602`. **No tratar como un proyecto independiente sin nuevos antecedentes**, para evitar duplicar Katherine.

### Prioridad media — Puerto Varas y entorno
- Casa Perez — Puerto Varas. Pendiente revisión visual.
- Kran — Puerto Varas. Pendiente revisión visual.
- San Francisco — Puerto Varas. Pendiente revisión visual.
- Klener — Puerto Varas. Pendiente revisión visual.

### Otros proyectos detectados para revisión
- Casa Gabriel Pequeño.
- Casa EyA (más de una carpeta/versionado).
- Casa Lukas.
- Casa E&M.
- Lago Rupanco / documentación asociada.
- Otros folders genéricos `Cocina` y `Quincho` que requieren identificar su proyecto padre antes de publicarlos.

## 4. Norma de incorporación de imágenes

Para evitar duplicados y archivos dañados:

1. Revisar si el proyecto ya existe en GitHub antes de crear carpeta.
2. Abrir visualmente las fotografías de Drive y descartar duplicados, capturas irrelevantes o fotos de baja calidad.
3. HEIC/HEIF de iPhone: convertir a WebP.
4. Para galerías: lado largo objetivo 1.000–1.400 px y WebP con compresión visual equilibrada.
5. Para miniaturas/listados: versión adicional de 400–700 px cuando sea útil.
6. Usar nombres SEO descriptivos, sin espacios ni caracteres especiales, por ejemplo `cocina-a-medida-puerto-montt-final.webp`.
7. Validar el archivo final localmente antes de subirlo.
8. Después de subir: comprobar tamaño, cabecera WebP y ruta en GitHub antes de referenciarlo desde HTML.
9. No utilizar archivos HEIC directamente en la web.
10. No mantener archivos temporales `.b64` u otros artefactos de transferencia en el repositorio.
11. No modificar `main` hasta revisar la rama de trabajo.

## 5. Estado del proyecto Katherine

Carpeta en la rama: `img/proyectos/depto-k/`.

Imágenes verificadas:
- `cocina-terminada-1.webp`: vista final real de la cocina.
- `cocina-terminada-2.webp`: segunda vista final real de la cocina.
- `diseno-previo.webp`: diseño/planificación.
- `proceso-obra-1.webp`: obra previa a la instalación de mobiliario.
- `proceso-obra-2.webp`: segunda vista del proceso de remodelación.

## 6. Estado de SEO y conversión

- Home rediseñada para búsquedas y conversión en Puerto Montt.
- SEO local reforzado con servicios, áreas atendidas, proyectos reales y FAQ visible.
- Datos estructurados `LocalBusiness`, `WebSite` y `FAQPage` incorporados en la home.
- Se eliminaron del nuevo diseño los testimonios hardcodeados no verificados y se sustituyeron por enlaces directos a Google.
- `sitemap.xml` actualizado con las páginas nuevas y fecha 2026-09-07.
- WhatsApp se mantiene como canal principal de conversión y el formulario de la home solo construye el mensaje; no almacena datos.