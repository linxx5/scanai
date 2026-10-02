"""Generate Flutter + Web themes from design/tokens.json — stdlib only, $0."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOKENS = ROOT / "design" / "tokens.json"
FLUTTER_OUT = ROOT / "app" / "lib" / "theme" / "theme.dart"
WEB_OUT = ROOT / "web" / "tokens.css"

def hex_to_flutter(hex_str: str) -> str:
    h = hex_str.lstrip("#")
    if len(h) == 6:
        h = "FF" + h
    return f"0x{h.upper()}"

def main() -> None:
    data = json.loads(TOKENS.read_text(encoding="utf-8"))
    c = data["color"]
    t = data["typography"]
    s = data["shape"]

    dart = f"""// GENERATED — do not edit. Edit design/tokens.json then run: python tools/generate_themes.py
import 'package:flutter/material.dart';

class ScanaiTokens {{
  static const primary = Color({hex_to_flutter(c['primary'])});
  static const onPrimary = Color({hex_to_flutter(c['onPrimary'])});
  static const secondary = Color({hex_to_flutter(c['secondary'])});
  static const error = Color({hex_to_flutter(c['error'])});
  static const warning = Color({hex_to_flutter(c['warning'])});
  static const success = Color({hex_to_flutter(c['success'])});
  static const surface = Color({hex_to_flutter(c['surface'])});
  static const onSurface = Color({hex_to_flutter(c['onSurface'])});
  static const ready = Color({hex_to_flutter(data['states']['ready'])});
  static const needsReview = Color({hex_to_flutter(data['states']['needsReview'])});
  static const failed = Color({hex_to_flutter(data['states']['failed'])});
  static const radiusSm = {float(s['radiusSmall']):.1f};
  static const radiusMd = {float(s['radiusMedium']):.1f};
  static const radiusLg = {float(s['radiusLarge']):.1f};
}}

ThemeData buildScanaiTheme() {{
  final scheme = ColorScheme.fromSeed(
    seedColor: ScanaiTokens.primary,
    error: ScanaiTokens.error,
    surface: ScanaiTokens.surface,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Roboto',
  );
}}
"""
    css = f""":root {{
  --scanai-primary: {c['primary']};
  --scanai-on-primary: {c['onPrimary']};
  --scanai-secondary: {c['secondary']};
  --scanai-error: {c['error']};
  --scanai-warning: {c['warning']};
  --scanai-success: {c['success']};
  --scanai-surface: {c['surface']};
  --scanai-on-surface: {c['onSurface']};
  --scanai-ready: {data['states']['ready']};
  --scanai-needs-review: {data['states']['needsReview']};
  --scanai-failed: {data['states']['failed']};
  --scanai-radius-sm: {s['radiusSmall']}px;
  --scanai-radius-md: {s['radiusMedium']}px;
  --scanai-radius-lg: {s['radiusLarge']}px;
  --scanai-font: {t['fontFamily']};
}}
"""

    FLUTTER_OUT.parent.mkdir(parents=True, exist_ok=True)
    WEB_OUT.parent.mkdir(parents=True, exist_ok=True)
    FLUTTER_OUT.write_text(dart, encoding="utf-8")
    WEB_OUT.write_text(css, encoding="utf-8")
    print(f"wrote {FLUTTER_OUT.relative_to(ROOT)} + {WEB_OUT.relative_to(ROOT)}")

if __name__ == "__main__":
    main()
