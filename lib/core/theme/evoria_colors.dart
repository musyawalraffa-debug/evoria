import 'package:flutter/material.dart';

/// EVORIA Color Tokens
/// Strictly adhering to the "Warm Solitude" Light Theme and
/// "Midnight Longing" Dark Theme approved design language.
class EvoriaColors {
  EvoriaColors._();

  // --- Light Theme: "Warm Solitude" ---
  static const Color lightBackground = Color(0xFFF5F0E8);
  static const Color lightSecondary = Color(0xFFF5EFE6);
  static const Color lightCards = Color(0xFFEAE0D3);
  static const Color lightPeach = Color(0xFFE9B99E);
  static const Color lightTerracotta = Color(0xFFA46B55);
  static const Color lightInk = Color(0xFF352823);
  static const Color lightMuted = Color(0xFF8D7769);

  // --- Dark Theme: "Midnight Longing" ---
  static const Color darkBackground = Color(0xFF272323);
  static const Color darkDeep = Color(0xFF1B1716);
  static const Color darkSurface = Color(0xFF342B29);
  static const Color darkAccent = Color(0xFFC58D73);
  static const Color darkText = Color(0xFFF5EBE1);
  static const Color darkMuted = Color(0xFFB8A69B);

  // --- Liquid Glass Specular & Refraction Tokens ---
  static const Color glassHighlightLight = Color(0x66FFFFFF);
  static const Color glassHighlightDark = Color(0x33FFFFFF);
  static const Color glassBorderLight = Color(0x40FFFFFF);
  static const Color glassBorderDark = Color(0x20FFFFFF);
  
  // Chromatic Aberration Dispersion Rims
  static const Color chromaticCyan = Color(0x6000E5FF);
  static const Color chromaticAmber = Color(0x60FFAB40);
  static const Color chromaticViolet = Color(0x60E040FB);
  static const Color chromaticRed = Color(0x60FF5252);
}
