import 'package:flutter/material.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/theme/evoria_shadows.dart';

class KenanganScreen extends StatefulWidget {
  const KenanganScreen({super.key});

  @override
  State<KenanganScreen> createState() => _KenanganScreenState();
}

class _KenanganScreenState extends State<KenanganScreen> {
  int _activeFilter = 0; // 0: Semua, 1: Bersama, 2: Pribadi, 3: Favorit
  bool _isGridView = true;

  final List<String> _filters = ['Semua', 'Bersama', 'Pribadi', 'Favorit'];

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
              'Kenangan',
              style: EvoriaTypography.editorialHeadline(
                color: textColor,
                fontSize: 24,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isGridView ? Icons.view_agenda_outlined : Icons.grid_view_rounded,
                  color: textColor,
                ),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: textColor,
                ),
                onPressed: () {
                  // Navigate to Add Memory
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Filter Chips Row
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: List.generate(_filters.length, (index) {
                  final bool isSelected = _activeFilter == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _activeFilter = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta)
                              : cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: (isDark
                                            ? EvoriaColors.darkAccent
                                            : EvoriaColors.lightTerracotta)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected ? Colors.white : textColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // Album & Memory Grid / List Content
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: _buildMemoriesGrid(isDark, cardColor, textColor, mutedColor),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 130), // Floating navbar spacing
          ),
        ],
      ),
    );
  }

  Widget _buildMemoriesGrid(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color mutedColor,
  ) {
    final List<Map<String, String>> dummyAlbums = [
      {
        'title': 'Perjalanan Danau Toba',
        'count': '24 Foto',
        'date': 'Oktober 2026',
        'type': 'Bersama',
      },
      {
        'title': 'Catatan Kafe Senja',
        'count': '12 Foto',
        'date': 'September 2026',
        'type': 'Bersama',
      },
      {
        'title': 'Sudut Rahasia Jiwa',
        'count': '7 Foto',
        'date': 'Agustus 2026',
        'type': 'Pribadi',
      },
      {
        'title': 'Perayaan Ulang Tahun',
        'count': '31 Foto',
        'date': 'Juli 2026',
        'type': 'Bersama',
      },
    ];

    if (_isGridView) {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.82,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final album = dummyAlbums[index % dummyAlbums.length];
            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(22),
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
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(22)),
                        color: isDark
                            ? const Color(0xFF382F2D)
                            : const Color(0xFFDFD1C2),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              Icons.photo_library_outlined,
                              size: 32,
                              color: isDark ? Colors.white30 : const Color(0xFF8D7769),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                album['type']!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album['title']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          album['count']!,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                            fontWeight: FontWeight.w500,
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
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final album = dummyAlbums[index % dummyAlbums.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
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
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: isDark
                            ? const Color(0xFF382F2D)
                            : const Color(0xFFDFD1C2),
                      ),
                      child: Icon(
                        Icons.photo_library_outlined,
                        color: isDark ? Colors.white30 : const Color(0xFF8D7769),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            album['title']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${album['count']} • ${album['date']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: mutedColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta)
                            .withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        album['type']!,
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
              ),
            );
          },
          childCount: 4,
        ),
      );
    }
  }
}
