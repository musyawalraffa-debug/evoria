import 'package:flutter/material.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/theme/evoria_shadows.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

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
          // Elegant Sanctuary App Bar with Subtle Leaf & Mountain Silhouette Accent
          SliverAppBar(
            pinned: false,
            floating: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(22, 50, 22, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '16 November 2026',
                          style: EvoriaTypography.uiCaption(
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Selamat Pagi, Jiwa',
                          style: EvoriaTypography.editorialTitle(
                            color: textColor,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                    // Couple Sanctuary Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isDark
                            ? EvoriaShadows.softCardDark
                            : EvoriaShadows.softCardLight,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Kalian Berdua',
                            style: EvoriaTypography.uiCaption(
                              color: textColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Sanctuary Feed
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // "Pada Hari Ini" Highlight Card
                  _buildOnThisDayCard(context, isDark, cardColor, textColor, mutedColor),
                  const SizedBox(height: 24),

                  // Featured Shared Moments Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kenangan Terpilih',
                        style: EvoriaTypography.editorialHeadline(
                          color: textColor,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Lihat Semua',
                        style: EvoriaTypography.uiCaption(
                          color: isDark
                              ? EvoriaColors.darkAccent
                              : EvoriaColors.lightTerracotta,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Horizontal Featured Stories
                  _buildFeaturedCarousel(context, isDark, cardColor, textColor, mutedColor),
                  const SizedBox(height: 24),

                  // Recent Reflections & Letters
                  Text(
                    'Goresan Rasa Terbaru',
                    style: EvoriaTypography.editorialHeadline(
                      color: textColor,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildReflectionSnippet(isDark, cardColor, textColor, mutedColor),

                  const SizedBox(height: 24),
                  // Sanctuary Soundtrack Mini Card
                  _buildSoundtrackSnippet(isDark, cardColor, textColor, mutedColor),

                  const SizedBox(height: 130), // Padding for floating navbar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnThisDayCard(
    BuildContext context,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color mutedColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? EvoriaShadows.softCardDark
            : EvoriaShadows.softCardLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history_rounded,
                size: 18,
                color: isDark
                    ? EvoriaColors.darkAccent
                    : EvoriaColors.lightTerracotta,
              ),
              const SizedBox(width: 8),
              Text(
                'PADA HARI INI • 2 TAHUN LALU',
                style: EvoriaTypography.uiCaption(
                  color: isDark
                      ? EvoriaColors.darkAccent
                      : EvoriaColors.lightTerracotta,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Senja Pertama di Bukit Pinus',
            style: EvoriaTypography.editorialHeadline(
              color: textColor,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"Udara dingin dan dua cangkir teh hangat. Kamu bilang waktu seolah berhenti di sini."',
            style: EvoriaTypography.uiBody(
              color: mutedColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (isDark
                          ? EvoriaColors.darkAccent
                          : EvoriaColors.lightTerracotta)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Buka Kenangan Penuh',
                  style: TextStyle(
                    fontSize: 12,
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
    );
  }

  Widget _buildFeaturedCarousel(
    BuildContext context,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color mutedColor,
  ) {
    return SizedBox(
      height: 190,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildMemoryCard(
            title: 'Tepi Danau Berdua',
            date: '12 Okt 2026',
            photosCount: '8 Foto',
            isDark: isDark,
            cardColor: cardColor,
            textColor: textColor,
            mutedColor: mutedColor,
          ),
          const SizedBox(width: 14),
          _buildMemoryCard(
            title: 'Kopi Hujan Sore Itu',
            date: '28 Sep 2026',
            photosCount: '5 Foto',
            isDark: isDark,
            cardColor: cardColor,
            textColor: textColor,
            mutedColor: mutedColor,
          ),
          const SizedBox(width: 14),
          _buildMemoryCard(
            title: 'Menyusuri Kota Tua',
            date: '14 Agu 2026',
            photosCount: '14 Foto',
            isDark: isDark,
            cardColor: cardColor,
            textColor: textColor,
            mutedColor: mutedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildMemoryCard({
    required String title,
    required String date,
    required String photosCount,
    required bool isDark,
    required Color cardColor,
    required Color textColor,
    required Color mutedColor,
  }) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? EvoriaShadows.softCardDark
            : EvoriaShadows.softCardLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subtle warm placeholder with scenic framing
          Container(
            height: 105,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              color: isDark
                  ? const Color(0xFF3F3532)
                  : const Color(0xFFDFCFC0),
            ),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: 28,
                color: isDark ? Colors.white38 : const Color(0xFF8D7769),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 11,
                        color: mutedColor,
                      ),
                    ),
                    Text(
                      photosCount,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? EvoriaColors.darkAccent
                            : EvoriaColors.lightTerracotta,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionSnippet(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color mutedColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22),
        boxShadow: isDark
            ? EvoriaShadows.softCardDark
            : EvoriaShadows.softCardLight,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isDark
                      ? EvoriaColors.darkAccent
                      : EvoriaColors.lightTerracotta)
                  .withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_stories_outlined,
              size: 22,
              color: isDark
                  ? EvoriaColors.darkAccent
                  : EvoriaColors.lightTerracotta,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Catatan Hati Kemarin Malam',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Terima kasih telah mendengar ceritaku...',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: mutedColor,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: mutedColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSoundtrackSnippet(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color mutedColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: (isDark ? Colors.white : Colors.black).withOpacity(0.04),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.music_note_rounded,
            size: 20,
            color: isDark
                ? EvoriaColors.darkAccent
                : EvoriaColors.lightTerracotta,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Lagu Kenangan: Debussy — Clair de Lune',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
          Icon(
            Icons.play_arrow_rounded,
            color: textColor,
          ),
        ],
      ),
    );
  }
}
