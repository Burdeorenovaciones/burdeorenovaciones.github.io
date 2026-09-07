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

## 3. Proyectos detectados en Drive que NO tienen página propia confirmada en GitHub

### Prioridad alta — Puerto Montt / conversión local
- Depto Katherine Chávez — Puerto Montt. Tiene fotografías de proceso, fotografías finales, HEIC y videos. **En incorporación.**
- Depto 1602 — Puerto Montt. Pendiente revisar fotografías finales.
- Depto Fabian — Puerto Montt. Pendiente revisar fotografías finales.
- Casa Muricio / Mauricio — Puerta Sur. Tiene portada, HEIC, PNG, videos y una subcarpeta WebP. Pendiente selección visual.

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
10. No modificar `main` hasta revisar la rama de trabajo.

## 5. Estado del proyecto Katherine

Carpeta creada en la rama: `img/proyectos/depto-k/`.

Los tres WebP actuales fueron verificados contra sus archivos fuente locales y corresponden a:
- vista final de cocina,
- segunda vista final de cocina,
- imagen de diseño/planificación.

Antes de publicar la página definitiva se incorporarán también imágenes de obra/proceso y se usarán versiones de mayor resolución para la galería final, manteniendo miniaturas ligeras para los listados.
