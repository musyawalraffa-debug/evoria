import 'package:flutter/material.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/widgets/liquid_glass_nav_bar.dart';

/// Standalone QA Demonstration Screen for the Reusable Liquid Glass Navbar.
/// Allows full interactive inspection of Idle, Hold, Drag, Chromatic Dispersion,
/// Spring Snap, Dark/Light modes, and Reduced-Motion behavior against varied backdrops.
class LiquidGlassShowcaseScreen extends StatefulWidget {
  const LiquidGlassShowcaseScreen({super.key});

  @override
  State<LiquidGlassShowcaseScreen> createState() =>
      _LiquidGlassShowcaseScreenState();
}

class _LiquidGlassShowcaseScreenState extends State<LiquidGlassShowcaseScreen> {
  int _selectedIndex = 0;
  bool _isDark = false;
  bool _forceReducedMotion = false;
  int _backgroundIndex = 0; // 0: Warm Matte, 1: Sunset Glow, 2: Deep Night Forest

  final List<LiquidNavItem> _navItems = const [
    LiquidNavItem(icon: Icons.home_rounded, label: 'Beranda'),
    LiquidNavItem(icon: Icons.photo_library_outlined, label: 'Kenangan'),
    LiquidNavItem(icon: Icons.travel_explore_rounded, label: 'Jelajah'),
    LiquidNavItem(icon: Icons.auto_stories_outlined, label: 'Refleksi'),
    LiquidNavItem(icon: Icons.person_outline_rounded, label: 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final Color textColor =
        _isDark ? EvoriaColors.darkText : EvoriaColors.lightInk;
    final Color mutedColor =
        _isDark ? EvoriaColors.darkMuted : EvoriaColors.lightMuted;
    final Color cardColor =
        _isDark ? EvoriaColors.darkSurface : EvoriaColors.lightCards;

    return Scaffold(
      backgroundColor: _isDark
          ? EvoriaColors.darkBackground
          : EvoriaColors.lightBackground,
      body: Stack(
        children: [
          // Dynamic Background Layers to test real optical blur & glass refraction
          Positioned.fill(
            child: _buildTestBackdrop(),
          ),

          // Main QA Showcase Content
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'SHOWCASE NAVIGASI',
                              style: EvoriaTypography.uiCaption(
                                color: _isDark
                                    ? EvoriaColors.darkAccent
                                    : EvoriaColors.lightTerracotta,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: (_isDark
                                        ? EvoriaColors.darkAccent
                                        : EvoriaColors.lightTerracotta)
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Tab: ${_navItems[_selectedIndex].label}',
                                style: EvoriaTypography.uiCaption(
                                  color: _isDark
                                      ? EvoriaColors.darkAccent
                                      : EvoriaColors.lightTerracotta,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Liquid Glass Navbar',
                          style: EvoriaTypography.editorialTitle(
                            color: textColor,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Verifikasi interaksi gestur, optical depth, chromatic dispersion, dan spring physics.',
                          style: EvoriaTypography.uiBody(
                            color: mutedColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // QA Control Panel
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (_isDark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(0.06),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Panel Uji Coba QA',
                                style: EvoriaTypography.uiBodyMedium(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTogglePill(
                                      label: _isDark ? 'Tema Gelap' : 'Tema Terang',
                                      icon: _isDark
                                          ? Icons.dark_mode_rounded
                                          : Icons.light_mode_rounded,
                                      isActive: _isDark,
                                      onTap: () {
                                        setState(() {
                                          _isDark = !_isDark;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildTogglePill(
                                      label: _forceReducedMotion
                                          ? 'Motion: Mati'
                                          : 'Motion: Aktif',
                                      icon: Icons.motion_photos_off_rounded,
                                      isActive: _forceReducedMotion,
                                      onTap: () {
                                        setState(() {
                                          _forceReducedMotion =
                                              !_forceReducedMotion;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Latar Belakang Uji:',
                                    style: EvoriaTypography.uiCaption(
                                      color: mutedColor,
                                    ),
                                  ),
                                  const Spacer(),
                                  _buildBackdropChoice('Matte', 0),
                                  const SizedBox(width: 6),
                                  _buildBackdropChoice('Sunset', 1),
                                  const SizedBox(width: 6),
                                  _buildBackdropChoice('Foto', 2),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Feature Checklist Card
                        _buildInteractionGuide(
                          textColor: textColor,
                          mutedColor: mutedColor,
                          cardColor: cardColor,
                        ),
                        const SizedBox(height: 140), // Spacing for floating navbar
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Liquid Glass Navigation Bar Component
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: LiquidGlassNavBar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: _navItems,
              isDark: _isDark,
              forceReducedMotion: _forceReducedMotion,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTogglePill({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive
              ? (_isDark
                  ? EvoriaColors.darkAccent.withOpacity(0.2)
                  : EvoriaColors.lightTerracotta.withOpacity(0.15))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive
                ? (_isDark
                    ? EvoriaColors.darkAccent
                    : EvoriaColors.lightTerracotta)
                : (_isDark ? Colors.white24 : Colors.black12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: _isDark ? EvoriaColors.darkText : EvoriaColors.lightInk,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: EvoriaTypography.uiCaption(
                  color: _isDark ? EvoriaColors.darkText : EvoriaColors.lightInk,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackdropChoice(String title, int index) {
    final bool isSelected = _backgroundIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _backgroundIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? (_isDark ? EvoriaColors.darkAccent : EvoriaColors.lightTerracotta)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (_isDark ? Colors.white24 : Colors.black12),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (_isDark ? Colors.white70 : Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionGuide({
    required Color textColor,
    required Color mutedColor,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Panduan Pengujian Interaksi Fisika',
            style: EvoriaTypography.editorialHeadline(
              color: textColor,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          _buildCheckItem(
            '1. Tap Langsung',
            'Sentuh tab tujuan: kapsul kaca meluncur halus dengan magnetic settle.',
            textColor,
            mutedColor,
          ),
          const SizedBox(height: 10),
          _buildCheckItem(
            '2. Press and Hold (~150ms)',
            'Tahan jari pada navbar: kapsul membesar +10%, terangkat 4dp, glow menguat.',
            textColor,
            mutedColor,
          ),
          const SizedBox(height: 10),
          _buildCheckItem(
            '3. Drag Bebas (Squash & Stretch)',
            'Geser horizontal: indikator meregang secara elastis mengikuti kecepatan jari.',
            textColor,
            mutedColor,
          ),
          const SizedBox(height: 10),
          _buildCheckItem(
            '4. Chromatic Aberration',
            'Geser cepat: tampak refraksi spektral sian & jingga di tepian luar kapsul.',
            textColor,
            mutedColor,
          ),
          const SizedBox(height: 10),
          _buildCheckItem(
            '5. Magnetic Snap saat Release',
            'Lepaskan jari: kapsul memantul lembut ke tab terdekat dengan simulasi pegas fisik.',
            textColor,
            mutedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(
    String title,
    String desc,
    Color textColor,
    Color mutedColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.lens_blur_rounded,
          size: 16,
          color: EvoriaColors.lightTerracotta,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12,
                  color: mutedColor,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTestBackdrop() {
    if (_backgroundIndex == 1) {
      // Sunset Gradient (Layered hills & sunset sky)
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isDark
                ? [
                    const Color(0xFF1B1716),
                    const Color(0xFF342B29),
                    const Color(0xFF4A342E),
                    const Color(0xFFC58D73).withOpacity(0.6),
                  ]
                : [
                    const Color(0xFFF5EFE6),
                    const Color(0xFFE9B99E).withOpacity(0.5),
                    const Color(0xFFA46B55).withOpacity(0.4),
                    const Color(0xFFF5F0E8),
                  ],
          ),
        ),
      );
    } else if (_backgroundIndex == 2) {
      // High contrast editorial pattern backdrop
      return Container(
        color: _isDark ? const Color(0xFF161313) : const Color(0xFFEDE5D9),
        child: CustomPaint(
          painter: _GridPatternPainter(
            color: _isDark
                ? Colors.white.withOpacity(0.05)
                : const Color(0xFF352823).withOpacity(0.06),
          ),
        ),
      );
    }
    // Default Matte
    return Container(
      color: _isDark ? EvoriaColors.darkBackground : EvoriaColors.lightBackground,
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  final Color color;

  _GridPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const double step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPatternPainter oldDelegate) =>
      oldDelegate.color != color;
}
