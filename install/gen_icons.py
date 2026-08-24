#!/usr/bin/env python3
"""Generate simple ox_inventory item icons."""
import struct
import zlib
from pathlib import Path

OUT = Path("/workspace/install/images")
OUT.mkdir(parents=True, exist_ok=True)
SIZE = 128


def chunk(tag: bytes, data: bytes) -> bytes:
    return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)


def write_png(path: Path, pixels: list[list[tuple[int, int, int, int]]]) -> None:
    raw = bytearray()
    for row in pixels:
        raw.append(0)
        for r, g, b, a in row:
            raw.extend((r, g, b, a))
    ihdr = struct.pack(">IIBBBBB", SIZE, SIZE, 8, 6, 0, 0, 0)
    path.write_bytes(
        b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", zlib.compress(bytes(raw), 9)) + chunk(b"IEND", b"")
    )


def lerp(a, b, t):
    return int(a + (b - a) * t)


def ellipse(px, py, cx, cy, rx, ry) -> bool:
    dx = (px - cx) / rx
    dy = (py - cy) / ry
    return dx * dx + dy * dy <= 1.0


def paw_mask(x, y) -> bool:
    pads = [
        (48, 42, 11, 15),
        (64, 32, 10, 14),
        (80, 42, 11, 15),
        (40, 62, 10, 12),
        (88, 62, 10, 12),
    ]
    if ellipse(x, y, 64, 88, 22, 18):
        return True
    return any(ellipse(x, y, cx, cy, rx, ry) for cx, cy, rx, ry in pads)


def circle(x, y, cx, cy, r) -> bool:
    return ellipse(x, y, cx, cy, r, r)


def dist_to_segment(px, py, x1, y1, x2, y2) -> float:
    dx, dy = x2 - x1, y2 - y1
    length = dx * dx + dy * dy
    if length == 0:
        return ((px - x1) ** 2 + (py - y1) ** 2) ** 0.5
    t = max(0.0, min(1.0, ((px - x1) * dx + (py - y1) * dy) / length))
    nx, ny = x1 + t * dx, y1 + t * dy
    return ((px - nx) ** 2 + (py - ny) ** 2) ** 0.5


def make_icon(bg, accent, kind: str) -> list[list[tuple[int, int, int, int]]]:
    pixels = []
    for y in range(SIZE):
        row = []
        for x in range(SIZE):
            t = y / SIZE
            r = lerp(bg[0], max(0, bg[0] - 28), t)
            g = lerp(bg[1], max(0, bg[1] - 28), t)
            b = lerp(bg[2], max(0, bg[2] - 28), t)
            # border
            if x < 4 or y < 4 or x >= SIZE - 4 or y >= SIZE - 4:
                row.append((accent[0], accent[1], accent[2], 255))
                continue
            glyph = False
            if kind == "paw":
                glyph = paw_mask(x, y)
            elif kind == "food":
                glyph = ellipse(x, y, 64, 78, 36, 14) or ellipse(x, y, 64, 62, 28, 22)
            elif kind == "water":
                glyph = ellipse(x, y, 64, 58, 18, 28) or ellipse(x, y, 64, 86, 22, 14)
            elif kind == "collar":
                glyph = ellipse(x, y, 64, 64, 34, 26) and not ellipse(x, y, 64, 64, 22, 16)
            elif kind == "leash":
                handle = ellipse(x, y, 46, 42, 20, 20) and not ellipse(x, y, 46, 42, 11, 11)
                strap = dist_to_segment(x, y, 58, 56, 88, 94) < 5.2
                clip = (ellipse(x, y, 94, 100, 10, 10) and not ellipse(x, y, 94, 100, 4, 4)) or circle(x, y, 88, 90, 4)
                glyph = handle or strap or clip
            elif kind == "revive":
                glyph = (58 <= x <= 70 and 36 <= y <= 92) or (36 <= x <= 92 and 58 <= y <= 70)
            if glyph:
                row.append((accent[0], accent[1], accent[2], 255))
            else:
                row.append((r, g, b, 255))
        pixels.append(row)
    return pixels


ICONS = {
    "pet_rottweiler": ((72, 38, 32), (232, 210, 176), "paw"),
    "pet_shepherd": ((70, 52, 32), (232, 210, 176), "paw"),
    "pet_husky": ((48, 62, 78), (232, 210, 176), "paw"),
    "pet_retriever": ((122, 84, 36), (232, 210, 176), "paw"),
    "pet_pug": ((96, 72, 54), (232, 210, 176), "paw"),
    "pet_poodle": ((90, 74, 102), (232, 210, 176), "paw"),
    "pet_chop": ((42, 38, 34), (232, 210, 176), "paw"),
    "pet_cat": ((122, 98, 52), (232, 210, 176), "paw"),
    "pet_rabbit": ((110, 104, 96), (232, 210, 176), "paw"),
    "pet_pig": ((128, 72, 88), (232, 210, 176), "paw"),
    "pet_food": ((92, 58, 28), (232, 186, 92), "food"),
    "pet_water": ((36, 78, 104), (168, 214, 230), "water"),
    "pet_collar": ((58, 42, 28), (201, 160, 90), "collar"),
    "pet_leash": ((46, 40, 30), (201, 160, 90), "leash"),
    "pet_revive": ((92, 32, 32), (232, 210, 176), "revive"),
}

for name, (bg, accent, kind) in ICONS.items():
    write_png(OUT / f"{name}.png", make_icon(bg, accent, kind))
    print("wrote", name)
