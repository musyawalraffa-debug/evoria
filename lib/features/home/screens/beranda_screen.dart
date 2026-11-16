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

class BerandaScreen extends ConsumerWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textColor =
        isDark ? EvoriaColors.darkText : EvoriaColors.lightInk;
    final Color mutedColor =
        isDark ? EvoriaColors.darkMuted : EvoriaColors.lightMuted;
    final Color cardColor =
        isDark ? EvoriaColors.darkSurface : EvoriaColors.lightCards;

    final profile = ref.watch(profileProvider);
    final memories = ref.watch(memoriesProvider);

    final nowStr = DateFormat('d MMMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          onPressed: () => context.push('/tambah-kenangan'),
          backgroundColor: isDark
              ? EvoriaColors.darkAccent
              : EvoriaColors.lightTerracotta,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: const Text(
            'Tambah Kenangan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          elevation: 4,
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Elegant Sanctuary App Bar
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
                          nowStr,
                          style: EvoriaTypography.uiCaption(
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Selamat Pagi, ${profile.partnerName}',
                          style: EvoriaTypography.editorialTitle(
                            color: textColor,
                            fontSize: 24,
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

                  // Couple Stats Card (Days Together)
                  _buildCoupleStatsCard(
                    context,
                    profile.daysTogether,
                    memories.length,
                    isDark,
                    cardColor,
                    textColor,
                    mutedColor,
                  ),
                  const SizedBox(height: 24),

                  // "Pada Hari Ini" Highlight Card
                  if (memories.isNotEmpty)
                    _buildFeaturedMemoryCard(
                      context,
                      memories.first,
                      isDark,
                      cardColor,
                      textColor,
                      mutedColor,
                    ),
                  const SizedBox(height: 24),

                  // All Memories Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Linimasa Kenangan',
                        style: EvoriaTypography.editorialHeadline(
                          color: textColor,
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/kenangan'),
                        child: Text(
                          'Lihat Semua (${memories.length})',
                          style: TextStyle(
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Memories List
          if (memories.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        size: 48,
                        color: mutedColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Belum ada kenangan yang tersimpan.',
                        style: TextStyle(color: mutedColor, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ketuk tombol "+ Tambah Kenangan" di bawah untuk mulai mengabadikan momen kalian.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: mutedColor.withOpacity(0.7), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = memories[index];
                    return _buildMemoryListItem(
                      context,
                      item,
                      isDark,
                      cardColor,
                      textColor,
                      mutedColor,
                    );
                  },
                  childCount: memories.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 120), // Bottom navbar space
          ),
        ],
      ),
    );
  }

  Widget _buildCoupleStatsCard(
    BuildContext context,
    int daysTogether,
    int totalMemories,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '$daysTogether',
                style: EvoriaTypography.editorialHeadline(
                  color: isDark
                      ? EvoriaColors.darkAccent
                      : EvoriaColors.lightTerracotta,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Hari Bersama',
                style: EvoriaTypography.uiCaption(color: mutedColor),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 36,
            color: mutedColor.withOpacity(0.2),
          ),
          Column(
            children: [
              Text(
                '$totalMemories',
                style: EvoriaTypography.editorialHeadline(
                  color: isDark
                      ? EvoriaColors.darkAccent
                      : EvoriaColors.lightTerracotta,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Kenangan Terukir',
                style: EvoriaTypography.uiCaption(color: mutedColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedMemoryCard(
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
        width: double.infinity,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(26),
          boxShadow: isDark
              ? EvoriaShadows.softCardDark
              : EvoriaShadows.softCardLight,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasImage)
              Image.file(
                File(item.imagePath!),
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 140,
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
                    Icons.auto_awesome_rounded,
                    size: 38,
                    color: (isDark
                            ? EvoriaColors.darkAccent
                            : EvoriaColors.lightTerracotta)
                        .withOpacity(0.6),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: (isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta)
                              .withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.mood,
                          style: TextStyle(
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('d MMM yyyy', 'id_ID').format(item.date),
                        style: TextStyle(color: mutedColor, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    style: EvoriaTypography.editorialHeadline(
                      color: textColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.note,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 13,
                      height: 1.4,
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

  Widget _buildMemoryListItem(
    BuildContext context,
    MemoryItem item,
    bool isDark,
    Color cardColor,
    Color textColor,
    Color mutedColor,
  ) {
    final hasImage = item.imagePath != null && File(item.imagePath!).existsSync();

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
                  width: 70,
                  height: 70,
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
                    Text(
                      DateFormat('d MMMM yyyy', 'id_ID').format(item.date),
                      style: TextStyle(
                        color: isDark
                            ? EvoriaColors.darkAccent
                            : EvoriaColors.lightTerracotta,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
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
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 13, color: mutedColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: mutedColor, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: mutedColor.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
