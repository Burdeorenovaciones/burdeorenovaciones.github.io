#!/usr/bin/env python3
"""Create lightweight, responsive WebP copies for the Burdeo homepage.

Original images are never modified. Generated assets are kept under
img/optimizadas/, and only <img> references in root index.html are changed.
Run from the repository root: python .github/scripts/optimize_homepage.py
"""
from __future__ import annotations

import json
import re
from pathlib import Path
from PIL import Image, ImageOps

ROOT = Path(__file__).resolve().parents[2]
INDEX = ROOT / "index.html"
OUT = ROOT / "img" / "optimizadas"

# (original path, output name, width candidates, responsive sizes, WebP quality)
SPECS = [
    ("img/LOGO BURDEO.png", "logo-burdeo", (256, 512), "(max-width: 700px) 72px, 130px", 93),
    ("img/equipo-burdeo-cocina-portada.webp", "equipo-cocina-portada", (540, 1080), "(max-width: 700px) 94vw, 48vw", 83),
    ("img/cocinas/edificio-puerto-montt/01-portada-cocina-edificio-puerto-montt.webp", "cocina-edificio-pm", (440, 880), "(max-width: 700px) 94vw, 24vw", 82),
    ("img/banos/valle-volcanes/01-portada-bano-valle-volcanes.webp", "bano-valle-volcanes", (440, 880), "(max-width: 700px) 94vw, 24vw", 82),
    ("img/quinchos/FT-Alerce/portada-quincho-ft.webp", "quincho-ft-alerce", (440, 880), "(max-width: 700px) 94vw, 24vw", 82),
    ("img/cocinas/las-quemas/01-portada-cocina-las-quemas.webp", "cocina-las-quemas", (440, 880), "(max-width: 700px) 94vw, 24vw", 82),
    ("img/equipo/Yisel-taller.jpg", "yisel-taller", (460, 920), "(max-width: 700px) 90vw, 36vw", 83),
    ("img/equipo/Trabajando.png", "equipo-trabajando", (460, 920), "(max-width: 700px) 90vw, 36vw", 83),
    ("img/cocinas/william-puertasur/portada.png", "cocina-william", (480, 960), "(max-width: 700px) 88vw, 360px", 83),
    ("img/cocinas/puerta-sur/luigui/portada.png", "cocina-luigi", (480, 960), "(max-width: 700px) 88vw, 360px", 83),
    ("img/cocinas/puerto-varas/katya1/portada-cocina-casa-katya.jpeg", "cocina-casa-katya", (480, 960), "(max-width: 700px) 88vw, 360px", 83),
    ("img/cocinas/frutillar/cocina-frutillar-portada.jpg", "cocina-frutillar", (480, 960), "(max-width: 700px) 88vw, 360px", 83),
    ("img/cocinas/muermos/chacana/portada-cocina-chacana-muermos.jpg", "cocina-chacana", (480, 960), "(max-width: 700px) 88vw, 360px", 83),
    ("img/cocinas/alerce/FT/portada-cocina-ft.jpg", "cocina-ft-alerce", (480, 960), "(max-width: 700px) 88vw, 360px", 83),
]


def set_dimension(tag: str, name: str, value: int) -> str:
    attr = re.compile(r'\s+' + name + r'\s*=\s*(["\']).*?\1', re.I)
    if attr.search(tag):
        return attr.sub(f' {name}="{value}"', tag, count=1)
    return tag[:-1] + f' {name}="{value}">'


def make_variants() -> tuple[dict, dict]:
    OUT.mkdir(parents=True, exist_ok=True)
    replacements, manifest = {}, {}
    for original, slug, widths, sizes, quality in SPECS:
        src = ROOT / original
        if not src.is_file():
            raise FileNotFoundError(f"Original asset missing: {original}")
        with Image.open(src) as source:
            image = ImageOps.exif_transpose(source)
            if image.mode in ("RGBA", "LA") or (
                image.mode == "P" and "transparency" in image.info
            ):
                image = image.convert("RGBA")
            else:
                image = image.convert("RGB")
            width, height = image.size
            variants = []
            for requested in widths:
                target = min(requested, width)
                if any(v["width"] == target for v in variants):
                    continue
                thumb = image.copy()
                if target < width:
                    new_height = max(1, round(height * target / width))
                    thumb = thumb.resize((target, new_height), Image.Resampling.LANCZOS)
                relative = f"img/optimizadas/{slug}-{target}.webp"
                output = ROOT / relative
                thumb.save(output, "WEBP", quality=quality, method=6)
                size = output.stat().st_size
                variants.append({"path": relative, "width": thumb.width, "height": thumb.height, "bytes": size})
        if not variants:
            raise RuntimeError(f"No optimized output created: {original}")
        variants.sort(key=lambda v: v["width"])
        replacements[original] = {
            "src": variants[-1]["path"],
            "srcset": ", ".join(f'{v["path"]} {v["width"]}w' for v in variants),
            "sizes": sizes,
            "width": width,
            "height": height,
        }
        manifest[original] = {
            "original_bytes": src.stat().st_size,
            "original_dimensions": [width, height],
            "variants": variants,
        }
        print(f'{original}: {src.stat().st_size:,} bytes -> ' + ', '.join(f'{v["width"]}px {v["bytes"]:,} bytes' for v in variants))
    return replacements, manifest


def update_home(replacements: dict) -> int:
    original = INDEX.read_text(encoding="utf-8")
    replaced = 0
    img_tag = re.compile(r"<img\b[^>]*>", re.I | re.S)
    src_re = re.compile(r'\bsrc\s*=\s*(["\'])(.*?)\1', re.I | re.S)

    def rewrite(match: re.Match) -> str:
        nonlocal replaced
        tag = match.group(0)
        m = src_re.search(tag)
        if not m or m.group(2) not in replacements:
            return tag
        source = m.group(2)
        info = replacements[source]
        # Idempotent when run again after the homepage references are updated.
        if re.search(r'\bsrcset\s*=', tag, re.I):
            raise RuntimeError(f"Unexpected existing srcset on {source}")
        attrs = f'src="{info["src"]}" srcset="{info["srcset"]}" sizes="{info["sizes"]}"'
        tag = tag[: m.start()] + attrs + tag[m.end() :]
        tag = set_dimension(tag, "width", info["width"])
        tag = set_dimension(tag, "height", info["height"])
        replaced += 1
        return tag

    updated = img_tag.sub(rewrite, original)

    # The old preload pointed to the Frutillar carousel image, not the LCP
    # hero photograph. Preload the new responsive hero image instead.
    preload_re = re.compile(r'<link\s+rel="preload"\s+as="image"[^>]*>', re.I)
    preloads = list(preload_re.finditer(updated))
    if len(preloads) != 1:
        raise RuntimeError(f"Expected one image preload; found {len(preloads)}")
    hero = replacements["img/equipo-burdeo-cocina-portada.webp"]
    preload = (f'<link rel="preload" as="image" href="{hero["src"]}" '
               f'imagesrcset="{hero["srcset"]}" imagesizes="{hero["sizes"]}" '
               'type="image/webp" fetchpriority="high">')
    updated = preload_re.sub(lambda _: preload, updated, count=1)

    # The page has 16 visible img elements (including two logos), plus the
    # empty lightbox img. Each visible image must now use an optimized copy.
    if replaced != 16:
        raise RuntimeError(f"Expected to update 16 <img> tags; updated {replaced}")
    if updated.count("<h1") != original.count("<h1"):
        raise RuntimeError("Unexpected change to the homepage heading count")
    if len(img_tag.findall(updated)) != len(img_tag.findall(original)):
        raise RuntimeError("Unexpected change to the number of image elements")
    if "https://wa.me/56967797864" not in updated or 'id="reviews"' not in updated:
        raise RuntimeError("Homepage CTA/reviews structure failed validation")

    INDEX.write_text(updated, encoding="utf-8")
    return replaced


def main() -> None:
    replacements, manifest = make_variants()
    updated = update_home(replacements)
    (OUT / "manifest.json").write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
    )
    print(f"Done: {updated} HTML image tags updated; {len(manifest)} original assets preserved.")


if __name__ == "__main__":
    main()
