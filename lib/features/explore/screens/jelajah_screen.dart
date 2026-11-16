import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/models/memory_item.dart';
import '../../../core/providers/sanctuary_providers.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/theme/evoria_shadows.dart';

class JelajahScreen extends ConsumerStatefulWidget {
  const JelajahScreen({super.key});

  @override
  ConsumerState<JelajahScreen> createState() => _JelajahScreenState();
}

class _JelajahScreenState extends ConsumerState<JelajahScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';

  final List<String> _suggestedQueries = [
    'Pantai',
    'Kopi',
    'Hujan',
    'Taman',
    'Romantis',
    'Hangat',
    'Bahagia',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _currentQuery = query.trim().toLowerCase();
    });
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

    final allMemories = ref.watch(memoriesProvider);

    final matchingMemories = _currentQuery.isEmpty
        ? <MemoryItem>[]
        : allMemories.where((m) {
            final t = m.title.toLowerCase();
            final l = m.location.toLowerCase();
            final n = m.note.toLowerCase();
            final mood = m.mood.toLowerCase();
            return t.contains(_currentQuery) ||
                l.contains(_currentQuery) ||
                n.contains(_currentQuery) ||
                mood.contains(_currentQuery);
          }).toList();

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
                    const SizedBox(height: 6),
                    Text(
                      'Temukan kembali serpihan rasa dan tempat kalian berdua.',
                      style: EvoriaTypography.uiBody(
                        color: mutedColor,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Search Field
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: isDark
                            ? EvoriaShadows.softCardDark
                            : EvoriaShadows.softCardLight,
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearch,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Cari tempat, suasana, atau momen...',
                          hintStyle: TextStyle(
                            color: mutedColor.withOpacity(0.6),
                            fontSize: 13,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearch('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Suggested Query Pills
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _suggestedQueries.map((query) {
                        return GestureDetector(
                          onTap: () {
                            _searchController.text = query;
                            _onSearch(query);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: (isDark
                                        ? EvoriaColors.glassBorderDark
                                        : EvoriaColors.glassBorderLight)
                                    .withOpacity(0.4),
                              ),
                            ),
                            child: Text(
                              query,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? EvoriaColors.darkAccent
                                    : EvoriaColors.lightTerracotta,
                                fontWeight: FontWeight.w500,
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

            // Search Results or Guidance
            if (_currentQuery.isNotEmpty)
              matchingMemories.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 48,
                                color: mutedColor.withOpacity(0.4),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tidak menemukan kenangan dengan kata "$_currentQuery".',
                                style: TextStyle(color: mutedColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.82,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = matchingMemories[index];
                            final hasImage = item.imagePath != null &&
                                File(item.imagePath!).existsSync();

                            return GestureDetector(
                              onTap: () => context.push('/detail-kenangan', extra: item),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: isDark
                                      ? EvoriaShadows.softCardDark
                                      : EvoriaShadows.softCardLight,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: hasImage
                                          ? Image.file(
                                              File(item.imagePath!),
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: isDark
                                                  ? const Color(0xFF382F2D)
                                                  : const Color(0xFFDFD1C2),
                                              child: Center(
                                                child: Icon(
                                                  Icons.photo_library_outlined,
                                                  size: 30,
                                                  color: mutedColor,
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
                                            item.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${item.location} • ${DateFormat("d MMM", "id_ID").format(item.date)}',
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
                              ),
                            );
                          },
                          childCount: matchingMemories.length,
                        ),
                      ),
                    )
            else
              // Guidance
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.travel_explore_rounded,
                          size: 56,
                          color: (isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta)
                              .withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Cari Kenangan Manis Kalian',
                          style: EvoriaTypography.editorialHeadline(
                            color: textColor,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ketik nama tempat, kata kunci cerita, atau pilih tag suasana hati di atas untuk mencari.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: mutedColor,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 140),
            ),
          ],
        ),
      ),
    );
  }
}
