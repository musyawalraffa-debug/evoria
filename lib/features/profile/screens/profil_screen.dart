import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/theme/evoria_shadows.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

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
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: isDark
                ? EvoriaColors.darkBackground.withOpacity(0.92)
                : EvoriaColors.lightBackground.withOpacity(0.92),
            elevation: 0,
            title: Text(
              'Profil & Suaka',
              style: EvoriaTypography.editorialHeadline(
                color: textColor,
                fontSize: 24,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Couple Identity Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isDark
                          ? EvoriaShadows.softCardDark
                          : EvoriaShadows.softCardLight,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Owner Avatar
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (isDark
                                        ? EvoriaColors.darkAccent
                                        : EvoriaColors.lightTerracotta)
                                    .withOpacity(0.2),
                              ),
                              child: Center(
                                child: Text(
                                  'R',
                                  style: EvoriaTypography.editorialTitle(
                                    color: isDark
                                        ? EvoriaColors.darkAccent
                                        : EvoriaColors.lightTerracotta,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            // Linked Hearts
                            Icon(
                              Icons.favorite_rounded,
                              size: 20,
                              color: isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta,
                            ),
                            const SizedBox(width: 14),
                            // Partner Avatar
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (isDark
                                        ? EvoriaColors.darkAccent
                                        : EvoriaColors.lightPeach)
                                    .withOpacity(0.3),
                              ),
                              child: Center(
                                child: Text(
                                  'D',
                                  style: EvoriaTypography.editorialTitle(
                                    color: isDark
                                        ? EvoriaColors.darkText
                                        : EvoriaColors.lightTerracotta,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Raffa & Dinda',
                                  style: EvoriaTypography.editorialHeadline(
                                    color: textColor,
                                    fontSize: 19,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '428 Hari Bersama • Menuju Selamanya',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: mutedColor,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: (isDark
                                        ? EvoriaColors.darkAccent
                                        : EvoriaColors.lightTerracotta)
                                    .withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Terhubung',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? EvoriaColors.darkAccent
                                      : EvoriaColors.lightTerracotta,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Showcase Navigation Card
                  GestureDetector(
                    onTap: () {
                      context.push('/showcase');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF3B2F2C),
                                  const Color(0xFF2E2422),
                                ]
                              : [
                                  const Color(0xFFF3E7D9),
                                  const Color(0xFFE8D6C4),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: (isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta)
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Showcase Liquid Glass Navbar',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Uji interaksi hold, drag elastis, chromatic aberration & snap',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: mutedColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sanctuary Stats Grid
                  Row(
                    children: [
                      _buildStatBox('84', 'Kenangan', cardColor, textColor, mutedColor, isDark),
                      const SizedBox(width: 10),
                      _buildStatBox('14', 'Album', cardColor, textColor, mutedColor, isDark),
                      const SizedBox(width: 10),
                      _buildStatBox('26', 'Refleksi', cardColor, textColor, mutedColor, isDark),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Settings Sections
                  Text(
                    'Pengaturan Suaka',
                    style: EvoriaTypography.editorialHeadline(
                      color: textColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildSettingsTile(
                    icon: Icons.fingerprint_rounded,
                    title: 'Kunci Aplikasi & Privasi',
                    subtitle: 'Sidik Jari, Face Unlock, PIN 6-Digit',
                    cardColor: cardColor,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),

                  _buildSettingsTile(
                    icon: Icons.cloud_done_outlined,
                    title: 'Penyimpanan & Cadangan',
                    subtitle: 'Google One / Drive Pribadi (Sinkronisasi Aman)',
                    cardColor: cardColor,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),

                  _buildSettingsTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifikasi & Pengingat',
                    subtitle: 'Undangan pasangan, EVORIA Share, Kapsul Waktu',
                    cardColor: cardColor,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),

                  _buildSettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: 'Tentang EVORIA',
                    subtitle: 'Versi 1.0.0 • Suaka cinta dua insan',
                    cardColor: cardColor,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 140), // Floating navbar spacing
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildStatBox(
    String value,
    String label,
    Color cardColor,
    Color textColor,
    Color mutedColor,
    bool isDark,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isDark
              ? EvoriaShadows.softCardDark
              : EvoriaShadows.softCardLight,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: EvoriaTypography.editorialHeadline(
                color: isDark
                    ? EvoriaColors.darkAccent
                    : EvoriaColors.lightTerracotta,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                color: mutedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color textColor,
    required Color mutedColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark
            ? EvoriaShadows.softCardDark
            : EvoriaShadows.softCardLight,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: isDark
                ? EvoriaColors.darkAccent
                : EvoriaColors.lightTerracotta,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: mutedColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: mutedColor,
          ),
        ],
      ),
    );
  }
}
