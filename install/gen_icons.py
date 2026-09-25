#!/usr/bin/env python3
"""Photorealistic icons are generated and keyed by process_images.py."""
from pathlib import Path

IMAGES = Path(__file__).resolve().parent / "images"
count = len(list(IMAGES.glob("pet_*.png")))
print(f"{count} companion icons already exist in {IMAGES}")
print("Re-run process_images.py if you replace the green-screen source portraits.")
