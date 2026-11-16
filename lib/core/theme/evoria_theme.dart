import 'package:flutter/material.dart';
import 'evoria_colors.dart';

@immutable
class EvoriaThemeExtension extends ThemeExtension<EvoriaThemeExtension> {
  final Color background;
  final Color surface;
  final Color cardBackground;
  final Color accent;
  final Color textPrimary;
  final Color textMuted;
  final Color glassBorder;
  final Color glassTint;

  const EvoriaThemeExtension({
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.accent,
    required this.textPrimary,
    required this.textMuted,
    required this.glassBorder,
    required this.glassTint,
  });

  @override
  EvoriaThemeExtension copyWith({
    Color? background,
    Color? surface,
    Color? cardBackground,
    Color? accent,
    Color? textPrimary,
    Color? textMuted,
    Color? glassBorder,
    Color? glassTint,
  }) {
    return EvoriaThemeExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      cardBackground: cardBackground ?? this.cardBackground,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      glassBorder: glassBorder ?? this.glassBorder,
      glassTint: glassTint ?? this.glassTint,
    );
  }

  @override
  EvoriaThemeExtension lerp(
    ThemeExtension<EvoriaThemeExtension>? other,
    double t,
  ) {
    if (other is! EvoriaThemeExtension) return this;
    return EvoriaThemeExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      glassBorder: Color.lerp(glassBorder, other.glassBorder, t)!,
      glassTint: Color.lerp(glassTint, other.glassTint, t)!,
    );
  }
}

class EvoriaTheme {
  EvoriaTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: EvoriaColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: EvoriaColors.lightTerracotta,
        secondary: EvoriaColors.lightPeach,
        surface: EvoriaColors.lightSecondary,
        onPrimary: Colors.white,
        onSecondary: EvoriaColors.lightInk,
        onSurface: EvoriaColors.lightInk,
      ),
      cardTheme: const CardTheme(
        color: EvoriaColors.lightCards,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      extensions: const [
        EvoriaThemeExtension(
          background: EvoriaColors.lightBackground,
          surface: EvoriaColors.lightSecondary,
          cardBackground: EvoriaColors.lightCards,
          accent: EvoriaColors.lightTerracotta,
          textPrimary: EvoriaColors.lightInk,
          textMuted: EvoriaColors.lightMuted,
          glassBorder: EvoriaColors.glassBorderLight,
          glassTint: Color(0x30F5F0E8),
        ),
      ],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: EvoriaColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: EvoriaColors.darkAccent,
        secondary: EvoriaColors.darkSurface,
        surface: EvoriaColors.darkDeep,
        onPrimary: EvoriaColors.darkDeep,
        onSecondary: EvoriaColors.darkText,
        onSurface: EvoriaColors.darkText,
      ),
      cardTheme: const CardTheme(
        color: EvoriaColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      extensions: const [
        EvoriaThemeExtension(
          background: EvoriaColors.darkBackground,
          surface: EvoriaColors.darkDeep,
          cardBackground: EvoriaColors.darkSurface,
          accent: EvoriaColors.darkAccent,
          textPrimary: EvoriaColors.darkText,
          textMuted: EvoriaColors.darkMuted,
          glassBorder: EvoriaColors.glassBorderDark,
          glassTint: Color(0x35272323),
        ),
      ],
    );
  }
}
