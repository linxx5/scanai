# Scanai design — code-first, no Figma needed

Single source of truth: `tokens.json` in this folder.

## How to use (2 minutes)

1. Edit `tokens.json` (change `primary` hex, radius, etc.)
2. Run the generator (free, no installs beyond Python):
   - `python tools/generate_themes.py`
3. Done — it rewrites:
   - `app/lib/theme/theme.dart` (Flutter Material 3)
   - `web/tokens.css` (Next.js CSS vars)

Commit all three. No weekly exports, no 3-file cap, works offline.

## Quick sketches

Need a flow? Use Excalidraw (free, offline) for 10-min boxes. No pixel-perfect needed for MVP.
Save PNGs here as `screens/*.png` (optional).
