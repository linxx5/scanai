// GENERATED — do not edit. Edit design/tokens.json then run: python tools/generate_themes.py
import 'package:flutter/material.dart';

class ScanaiTokens {
  static const primary = Color(0xFF0B6B4F);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFF4A6572);
  static const error = Color(0xFFBA1A1A);
  static const warning = Color(0xFFB7791F);
  static const success = Color(0xFF0B6B4F);
  static const surface = Color(0xFFFCFDF7);
  static const onSurface = Color(0xFF191C1A);
  static const ready = Color(0xFF0B6B4F);
  static const needsReview = Color(0xFFB7791F);
  static const failed = Color(0xFFBA1A1A);
  static const radiusSm = 8.0;
  static const radiusMd = 12.0;
  static const radiusLg = 16.0;
}

ThemeData buildScanaiTheme() {
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
}
