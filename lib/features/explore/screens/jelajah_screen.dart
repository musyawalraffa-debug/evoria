import 'package:flutter/material.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/theme/evoria_shadows.dart';

class JelajahScreen extends StatefulWidget {
  const JelajahScreen({super.key});

  @override
  State<JelajahScreen> createState() => _JelajahScreenState();
}

class _JelajahScreenState extends State<JelajahScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;

  final List<String> _suggestedQueries = [
    'foto kita waktu sunset di pantai',
    'senyum manis saat hujan',
    'kopi berdua di sore hari',
    'jalan santai di taman',
    'momen ulang tahun kemarin',
  ];

  @override
  void dispose() {
    _searchController.dispose();
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
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pencarian Cerdas Kenangan',
                      style: EvoriaTypography.editorialHeadline(
                        color: textColor,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Temukan foto dengan deskripsi bahasa alami seperti "waktu sunset di pantai".',
                      style: EvoriaTypography.uiBody(
                        color: mutedColor,
                        fontSize: 13.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Natural Language Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isDark
                            ? EvoriaShadows.softCardDark
                            : EvoriaShadows.softCardLight,
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: textColor, fontSize: 14.5),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            setState(() {
                              _hasSearched = true;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari: foto kita waktu di pantai...',
                          hintStyle: TextStyle(
                            color: mutedColor.withOpacity(0.7),
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.search_rounded,
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _hasSearched = false;
                                    });
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Privacy & AI Provider Disclosure Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: (isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta)
                            .withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: 16,
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Privasi Terjamin: Pemrosesan teks dilakukan secara privat tanpa membagikan foto ke pihak ketiga tanpa izin.',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? EvoriaColors.darkAccent
                                    : EvoriaColors.lightTerracotta,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Suggestions Title
                    Text(
                      'Saran Deskripsi Alami',
                      style: EvoriaTypography.uiBodyMedium(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Suggestion Chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _suggestedQueries.map((query) {
                        return GestureDetector(
                          onTap: () {
                            _searchController.text = query;
                            setState(() {
                              _hasSearched = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: (isDark ? Colors.white : Colors.black)
                                    .withOpacity(0.05),
                              ),
                            ),
                            child: Text(
                              query,
                              style: TextStyle(
                                fontSize: 12.5,
                                color: textColor,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Search Results or Empty State
            if (_hasSearched)
              _buildSearchResults(isDark, cardColor, textColor, mutedColor)
            else
              _buildInitialGuidance(isDark, cardColor, textColor, mutedColor),

            const SliverToBoxAdapter(
              child: SizedBox(height: 140), // Floating navbar spacing
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color mutedColor,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: isDark
                    ? EvoriaShadows.softCardDark
                    : EvoriaShadows.softCardLight,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF382F2D)
                            : const Color(0xFFDFD1C2),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: 30,
                          color: isDark ? Colors.white30 : const Color(0xFF8D7769),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Momen Senja di Pantai',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Relevansi 94% • 12 Okt 2026',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: 4,
        ),
      ),
    );
  }

  Widget _buildInitialGuidance(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color mutedColor,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor.withOpacity(0.6),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            children: [
              Icon(
                Icons.auto_awesome_outlined,
                size: 36,
                color: isDark
                    ? EvoriaColors.darkAccent
                    : EvoriaColors.lightTerracotta,
              ),
              const SizedBox(height: 12),
              Text(
                'Mencari Memori dengan Bahasa Hati',
                textAlign: TextAlign.center,
                style: EvoriaTypography.editorialHeadline(
                  color: textColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tuliskan suasana, pakaian yang dikenakan, cuaca, atau lokasi untuk menemukan momen berdua secara instan.',
                textAlign: TextAlign.center,
                style: EvoriaTypography.uiBody(
                  color: mutedColor,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
