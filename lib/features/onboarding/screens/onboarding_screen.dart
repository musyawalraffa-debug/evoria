import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/theme/evoria_shadows.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Hanya Untuk Kalian Berdua',
      'subtitle':
          'Sebuah suaka privat yang dirancang eksklusif hanya untuk tepat dua orang: dirimu dan pasangan tercinta.',
      'icon': Icons.favorite_border_rounded,
      'badge': 'Eksklusif & Intim',
    },
    {
      'title': 'Abadikan Kisah & Refleksi',
      'subtitle':
          'Simpan foto kenangan, jurnal harian, surat yang belum terkirim, dan kapsul waktu untuk dibuka di masa depan.',
      'icon': Icons.auto_stories_outlined,
      'badge': 'Penyimpanan Abadi',
    },
    {
      'title': 'Perlindungan Tanpa Kompromi',
      'subtitle':
          'Kunci aplikasi dengan sidik jari, pemindai wajah, dan PIN 6-digit rahasia. Memori pribadimu tetap aman.',
      'icon': Icons.fingerprint_rounded,
      'badge': 'Keamanan Tingkat Tinggi',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor =
        isDark ? EvoriaColors.darkText : EvoriaColors.lightInk;
    final Color mutedColor =
        isDark ? EvoriaColors.darkMuted : EvoriaColors.lightMuted;
    final Color cardColor =
        isDark ? EvoriaColors.darkSurface : EvoriaColors.lightCards;

    return Scaffold(
      backgroundColor: isDark
          ? EvoriaColors.darkBackground
          : EvoriaColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              context.go('/google-signin');
            },
            child: Text(
              'Lewati',
              style: TextStyle(
                color: isDark
                    ? EvoriaColors.darkAccent
                    : EvoriaColors.lightTerracotta,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Editorial Sanctuary Artwork Frame
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(36),
                            boxShadow: isDark
                                ? EvoriaShadows.softCardDark
                                : EvoriaShadows.softCardLight,
                          ),
                          child: Center(
                            child: Icon(
                              page['icon'] as IconData,
                              size: 72,
                              color: isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: (isDark
                                    ? EvoriaColors.darkAccent
                                    : EvoriaColors.lightTerracotta)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            page['badge'] as String,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          page['title'] as String,
                          textAlign: TextAlign.center,
                          style: EvoriaTypography.editorialTitle(
                            color: textColor,
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          page['subtitle'] as String,
                          textAlign: TextAlign.center,
                          style: EvoriaTypography.uiBody(
                            color: mutedColor,
                            fontSize: 14.5,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicator Dots & Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot Indicators
                  Row(
                    children: List.generate(_pages.length, (index) {
                      final bool isSelected = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(right: 6),
                        width: isSelected ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta)
                              : mutedColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Floating Navigation Button
                  GestureDetector(
                    onTap: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/google-signin');
                      }
                    },
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: isDark
                            ? EvoriaColors.darkAccent
                            : EvoriaColors.lightTerracotta,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isDark
                                    ? EvoriaColors.darkAccent
                                    : EvoriaColors.lightTerracotta)
                                .withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
