import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/theme/evoria_shadows.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),

              // Visual Framing Card (Artistic sanctuary motif)
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: isDark
                      ? EvoriaShadows.softCardDark
                      : EvoriaShadows.softCardLight,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_vintage_outlined,
                        size: 48,
                        color: isDark
                            ? EvoriaColors.darkAccent
                            : EvoriaColors.lightTerracotta,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'EVORIA',
                        style: EvoriaTypography.editorialHeadline(
                          color: textColor,
                          fontSize: 22,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Suaka Kenangan Dua Insan',
                        style: TextStyle(
                          fontSize: 12,
                          color: mutedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 1),

              Text(
                'Selamat Datang di Suaka Pribadimu',
                style: EvoriaTypography.editorialTitle(
                  color: textColor,
                  fontSize: 32,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ruang tenang dan intim untuk merawat kenangan, cerita, dan janji yang hanya dimiliki kalian berdua.',
                style: EvoriaTypography.uiBody(
                  color: mutedColor,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const Spacer(flex: 2),

              // Primary Action: Mulai Melangkah
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/onboarding');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? EvoriaColors.darkAccent
                        : EvoriaColors.lightTerracotta,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Mulai Melangkah',
                    style: EvoriaTypography.uiButton(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Secondary Action: Masuk Akun
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/google-signin');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: (isDark ? Colors.white : Colors.black)
                          .withOpacity(0.12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Masuk dengan Akun Tersimpan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
