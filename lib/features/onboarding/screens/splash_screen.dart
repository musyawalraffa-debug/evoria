import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();

    Timer(const Duration(milliseconds: 2400), () {
      if (mounted) {
        context.go('/welcome');
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor =
        isDark ? EvoriaColors.darkText : EvoriaColors.lightInk;
    final Color mutedColor =
        isDark ? EvoriaColors.darkMuted : EvoriaColors.lightMuted;

    return Scaffold(
      backgroundColor: isDark
          ? EvoriaColors.darkBackground
          : EvoriaColors.lightBackground,
      body: Stack(
        children: [
          // Subtle warm sunset glow background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 0.9,
                  colors: isDark
                      ? [
                          const Color(0xFF382924),
                          EvoriaColors.darkBackground,
                        ]
                      : [
                          const Color(0xFFF9E7D8),
                          EvoriaColors.lightBackground,
                        ],
                ),
              ),
            ),
          ),

          // Central sanctuary title and poetic tagline
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Atmospheric sanctuary motif: empty bench & gentle tree outline
                  Icon(
                    Icons.park_outlined,
                    size: 42,
                    color: isDark
                        ? EvoriaColors.darkAccent
                        : EvoriaColors.lightTerracotta,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'EVORIA',
                    style: EvoriaTypography.editorialTitle(
                      color: textColor,
                      fontSize: 38,
                      letterSpacing: 4.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sebuah tempat yang pernah kau singgahi',
                    style: EvoriaTypography.editorialHeadline(
                      color: mutedColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A place you\'ve been before',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: mutedColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
