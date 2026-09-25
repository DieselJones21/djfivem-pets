#!/usr/bin/env python3
"""Key green-screen pet portraits to transparent 512px icons."""
from pathlib import Path

import numpy as np
from PIL import Image, ImageFilter

SRC = Path("/opt/cursor/artifacts/assets")
OUTS = [
    Path("/workspace/html/images"),
    Path("/workspace/install/images"),
]
SIZE = 512
PAD = 18


def key_green(arr: np.ndarray) -> np.ndarray:
    r = arr[:, :, 0]
    g = arr[:, :, 1]
    b = arr[:, :, 2]
    max_rb = np.maximum(r, b)
    greenness = np.clip((g - max_rb) / 55.0, 0.0, 1.0)
    near_screen = (g > 90) & (g > r * 1.18) & (g > b * 1.10)
    alpha = np.where(near_screen, 255.0 * (1.0 - greenness), 255.0)
    alpha = np.where(greenness > 0.72, 0.0, alpha)

    excess = np.maximum(0.0, g - max_rb)
    arr[:, :, 1] = np.clip(g - excess * 0.9, 0, 255)
    # pull leftover green fringe toward neighboring red/blue
    arr[:, :, 0] = np.clip(r + excess * 0.08, 0, 255)
    arr[:, :, 2] = np.clip(b + excess * 0.08, 0, 255)
    arr[:, :, 3] = alpha
    return arr


def crop_subject(im: Image.Image) -> Image.Image:
    alpha = np.array(im.split()[-1])
    ys, xs = np.where(alpha > 12)
    if len(xs) == 0:
        return im
    left, right = int(xs.min()), int(xs.max())
    top, bottom = int(ys.min()), int(ys.max())
    left = max(0, left - PAD)
    top = max(0, top - PAD)
    right = min(im.width, right + PAD)
    bottom = min(im.height, bottom + PAD)
    return im.crop((left, top, right, bottom))


def fit_square(im: Image.Image) -> Image.Image:
    w, h = im.size
    side = max(w, h)
    canvas = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    canvas.paste(im, ((side - w) // 2, (side - h) // 2), im)
    return canvas.resize((SIZE, SIZE), Image.Resampling.LANCZOS)


def process(src: Path) -> Image.Image:
    im = Image.open(src).convert("RGBA")
    arr = np.array(im).astype(np.float32)
    arr = key_green(arr)
    out = Image.fromarray(arr.astype(np.uint8), "RGBA")
    out = out.filter(ImageFilter.UnsharpMask(radius=1.1, percent=85, threshold=3))
    out = crop_subject(out)
    return fit_square(out)


def main() -> None:
    for dest in OUTS:
        dest.mkdir(parents=True, exist_ok=True)

    files = sorted(SRC.glob("pet_*.png"))
    if not files:
        raise SystemExit(f"No source images in {SRC}")

    for src in files:
        image = process(src)
        for dest in OUTS:
            image.save(dest / src.name, "PNG", optimize=True)
        print("processed", src.name)

    print("done", len(files))


if __name__ == "__main__":
    main()
