import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvoriaTypography {
  EvoriaTypography._();

  static TextStyle editorialTitle({
    required Color color,
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w600,
    double letterSpacing = -0.5,
    FontStyle fontStyle = FontStyle.normal,
    double? height,
  }) {
    return GoogleFonts.playfairDisplay(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle,
      height: height,
    );
  }

  static TextStyle editorialHeadline({
    required Color color,
    double fontSize = 22,
    FontWeight fontWeight = FontWeight.w600,
    double letterSpacing = -0.3,
    double? height,
  }) {
    return GoogleFonts.playfairDisplay(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle uiBody({
    required Color color,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w400,
    double height = 1.45,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
    );
  }

  static TextStyle uiBodyMedium({
    required Color color,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    );
  }

  static TextStyle uiCaption({
    required Color color,
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
    FontWeight? fontWeightOverride,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.2,
    );
  }

  static TextStyle uiButton({
    required Color color,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: 0.1,
    );
  }
}
