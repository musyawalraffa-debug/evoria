import 'package:flutter/material.dart';

class EvoriaShadows {
  EvoriaShadows._();

  static List<BoxShadow> softCardLight = [
    BoxShadow(
      color: const Color(0xFF352823).withOpacity(0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF352823).withOpacity(0.02),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> softCardDark = [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> liquidNavbarLight = [
    BoxShadow(
      color: const Color(0xFF352823).withOpacity(0.08),
      blurRadius: 28,
      spreadRadius: 0,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: const Color(0xFF352823).withOpacity(0.03),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> liquidNavbarDark = [
    BoxShadow(
      color: Colors.black.withOpacity(0.45),
      blurRadius: 32,
      spreadRadius: 2,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> activeCapsuleLift = [
    BoxShadow(
      color: const Color(0xFFA46B55).withOpacity(0.22),
      blurRadius: 14,
      spreadRadius: 1,
      offset: const Offset(0, 4),
    ),
  ];
}
