import 'package:flutter/material.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/theme/evoria_shadows.dart';

class RefleksiScreen extends StatefulWidget {
  const RefleksiScreen({super.key});

  @override
  State<RefleksiScreen> createState() => _RefleksiScreenState();
}

class _RefleksiScreenState extends State<RefleksiScreen> {
  int _selectedCategory = 0; // 0: Jurnal, 1: Surat, 2: Mood, 3: Kapsul Waktu
  int _selectedMood = 1; // 0: Senang, 1: Hangat, 2: Rindu, 3: Tenang, 4: Lelah

  final List<String> _categories = [
    'Jurnal Harian',
    'Surat Belum Terkirim',
    'Mood & Rasa',
    'Kapsul Waktu',
  ];

  final List<Map<String, dynamic>> _moodList = [
    {'label': 'Senang', 'icon': Icons.sentiment_very_satisfied_rounded},
    {'label': 'Hangat', 'icon': Icons.favorite_border_rounded},
    {'label': 'Rindu', 'icon': Icons.volunteer_activism_outlined},
    {'label': 'Tenang', 'icon': Icons.spa_outlined},
    {'label': 'Lelah', 'icon': Icons.nightlight_round},
  ];

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
              'Refleksi Jiwa',
              style: EvoriaTypography.editorialHeadline(
                color: textColor,
                fontSize: 24,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.edit_note_rounded,
                  color: textColor,
                ),
                onPressed: () {
                  // Open Entry Editor
                },
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Category Selector Pills
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: List.generate(_categories.length, (index) {
                  final bool isSelected = _selectedCategory == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = index;
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
                        ),
                        child: Text(
                          _categories[index],
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

          // Daily Prompt & Mood Check-in Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Mood Check-In Widget
                  Container(
                    padding: const EdgeInsets.all(18),
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
                        Text(
                          'Bagaimana hatimu hari ini?',
                          style: EvoriaTypography.uiBodyMedium(
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(_moodList.length, (index) {
                            final mood = _moodList[index];
                            final bool isCurrent = _selectedMood == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedMood = index;
                                });
                              },
                              child: Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isCurrent
                                          ? (isDark
                                              ? EvoriaColors.darkAccent
                                              : EvoriaColors.lightTerracotta)
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      mood['icon'] as IconData,
                                      size: 22,
                                      color: isCurrent
                                          ? Colors.white
                                          : mutedColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    mood['label'] as String,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isCurrent
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isCurrent ? textColor : mutedColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Daily Reflection Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                        Text(
                          'PERTANYAAN REFLEKSI HARI INI',
                          style: EvoriaTypography.uiCaption(
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '"Hal kecil apa dari pasanganmu hari ini yang diam-diam membuatmu bersyukur?"',
                          style: EvoriaTypography.editorialHeadline(
                            color: textColor,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ketuk untuk menuliskan jawaban berdua...',
                          style: TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section Title
                  Text(
                    _selectedCategory == 1
                        ? 'Surat yang Belum Terkirim'
                        : _selectedCategory == 3
                            ? 'Kapsul Waktu yang Terkunci'
                            : 'Catatan Jurnal',
                    style: EvoriaTypography.editorialHeadline(
                      color: textColor,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Content List depending on Category
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: _buildCategoryList(isDark, cardColor, textColor, mutedColor),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 140), // Floating navbar spacing
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(
    bool isDark,
    Color cardColor,
    Color textColor,
    Color mutedColor,
  ) {
    if (_selectedCategory == 1) {
      // Unsent Letters
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '10 November 2026',
                        style: TextStyle(fontSize: 11, color: mutedColor),
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Tersimpan Rapat',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ketika Kamu Tertidur di Perjalanan',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Aku memandang wajah lelahmu dan berjanji dalam hati untuk selalu menjaga langkahmu...',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: mutedColor,
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: 2,
        ),
      );
    } else if (_selectedCategory == 3) {
      // Time Capsule
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(20),
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
                  Row(
                    children: [
                      Icon(
                        Icons.lock_clock_rounded,
                        size: 20,
                        color: isDark
                            ? EvoriaColors.darkAccent
                            : EvoriaColors.lightTerracotta,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Kapsul Tersegel Hingga 31 Des 2027',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? EvoriaColors.darkAccent
                              : EvoriaColors.lightTerracotta,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Harapan dan Janji di Tahun Kelima',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Hanya dapat dibuka bersama saat waktu hitung mundur selesai.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: mutedColor,
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: 1,
        ),
      );
    }

    // Default Journal Entries
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '14 November 2026',
                      style: TextStyle(fontSize: 11.5, color: mutedColor),
                    ),
                    Text(
                      'Bersama Pasangan',
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
                const SizedBox(height: 8),
                Text(
                  'Malam yang Damai di Sudut Kota',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kami berjalan kaki tanpa arah tujuan, hanya menikmati desir angin dan hangat genggaman tangan.',
                  style: TextStyle(fontSize: 13, color: mutedColor, height: 1.4),
                ),
              ],
            ),
          );
        },
        childCount: 3,
      ),
    );
  }
}
