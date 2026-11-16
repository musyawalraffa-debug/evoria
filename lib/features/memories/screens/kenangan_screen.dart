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

class KenanganScreen extends ConsumerStatefulWidget {
  const KenanganScreen({super.key});

  @override
  ConsumerState<KenanganScreen> createState() => _KenanganScreenState();
}

class _KenanganScreenState extends ConsumerState<KenanganScreen> {
  String _activeFilter = 'Semua';
  bool _isGridView = true;

  final List<String> _filters = [
    'Semua',
    'Favorit',
    'Bahagia',
    'Hangat',
    'Tenang',
    'Rindu',
    'Romantis',
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

    final allMemories = ref.watch(memoriesProvider);

    // Apply Filter
    final filteredMemories = allMemories.where((m) {
      if (_activeFilter == 'Semua') return true;
      if (_activeFilter == 'Favorit') return m.isFavorite;
      return m.mood == _activeFilter;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () => context.push('/tambah-kenangan'),
          backgroundColor: isDark
              ? EvoriaColors.darkAccent
              : EvoriaColors.lightTerracotta,
          elevation: 4,
          child: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
        ),
      ),
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
              'Galeri Kenangan',
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
                icon: Icon(Icons.add_rounded, color: textColor),
                onPressed: () => context.push('/tambah-kenangan'),
              ),
            ],
          ),

          // Horizontal Filter Chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = _activeFilter == filter;

                  return Center(
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: isDark
                          ? EvoriaColors.darkAccent
                          : EvoriaColors.lightTerracotta,
                      backgroundColor: cardColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : textColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 13,
                      ),
                      onSelected: (val) {
                        if (val) {
                          setState(() => _activeFilter = filter);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Empty State
          if (filteredMemories.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.collections_bookmark_outlined,
                        size: 48,
                        color: mutedColor.withOpacity(0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tidak ada kenangan untuk filter "$_activeFilter".',
                        style: TextStyle(color: mutedColor, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => context.push('/tambah-kenangan'),
                        icon: const Icon(Icons.add),
                        label: const Text('Buat Kenangan Sekarang'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (_isGridView)
            // Grid View
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.76,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = filteredMemories[index];
                    return _buildGridCard(
                      context,
                      item,
                      isDark,
                      cardColor,
                      textColor,
                      mutedColor,
                    );
                  },
                  childCount: filteredMemories.length,
                ),
              ),
            )
          else
            // List View
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = filteredMemories[index];
                    return _buildListCard(
                      context,
                      item,
                      isDark,
                      cardColor,
                      textColor,
                      mutedColor,
                    );
                  },
                  childCount: filteredMemories.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(
    BuildContext context,
    MemoryItem item,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color mutedColor,
  ) {
    final hasImage = item.imagePath != null && File(item.imagePath!).existsSync();

    return GestureDetector(
      onTap: () => context.push('/detail-kenangan', extra: item),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
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
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF453028), const Color(0xFF272323)]
                              : [const Color(0xFFF3DEC8), const Color(0xFFEAD4BF)],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.photo_library_outlined,
                          size: 36,
                          color: (isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta)
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.mood,
                        style: TextStyle(
                          color: isDark
                              ? EvoriaColors.darkAccent
                              : EvoriaColors.lightTerracotta,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (item.isFavorite)
                        const Icon(Icons.favorite_rounded, size: 14, color: Colors.redAccent),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('d MMM yyyy', 'id_ID').format(item.date),
                    style: TextStyle(color: mutedColor, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(
    BuildContext context,
    MemoryItem item,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color mutedColor,
  ) {
    final hasImage = item.imagePath != null && File(item.imagePath!).existsSync();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () => context.push('/detail-kenangan', extra: item),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDark
                ? EvoriaShadows.softCardDark
                : EvoriaShadows.softCardLight,
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 76,
                  height: 76,
                  child: hasImage
                      ? Image.file(
                          File(item.imagePath!),
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: isDark
                              ? const Color(0xFF382924)
                              : const Color(0xFFF9E7D8),
                          child: Icon(
                            Icons.photo_library_outlined,
                            size: 28,
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.mood,
                          style: TextStyle(
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('d MMMM yyyy', 'id_ID').format(item.date),
                          style: TextStyle(color: mutedColor, fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.note,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: mutedColor, fontSize: 12, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
