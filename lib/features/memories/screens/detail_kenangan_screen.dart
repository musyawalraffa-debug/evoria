import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/models/memory_item.dart';
import '../../../core/providers/sanctuary_providers.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';

class DetailKenanganScreen extends ConsumerStatefulWidget {
  final MemoryItem memory;

  const DetailKenanganScreen({super.key, required this.memory});

  @override
  ConsumerState<DetailKenanganScreen> createState() => _DetailKenanganScreenState();
}

class _DetailKenanganScreenState extends ConsumerState<DetailKenanganScreen> {
  late MemoryItem _currentMemory;

  @override
  void initState() {
    super.initState();
    _currentMemory = widget.memory;
  }

  void _sendReaction(String emoji, String reactionName) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? EvoriaColors.darkSurface
            : EvoriaColors.lightCards,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          '$emoji Reaksi Pasangan',
          style: EvoriaTypography.editorialHeadline(
            color: Theme.of(context).brightness == Brightness.dark
                ? EvoriaColors.darkText
                : EvoriaColors.lightInk,
            fontSize: 20,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tuliskan bisikan kecil atau tanggapan hangat untuk kenangan ini:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                hintText: 'Misal: Aku juga ingat senyumanmu...',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(memoriesProvider.notifier).addReaction(
                    _currentMemory.id,
                    reactionName,
                    noteController.text.trim().isEmpty
                        ? 'Telah memeluk kenangan ini dengan cinta.'
                        : noteController.text.trim(),
                  );
              setState(() {
                _currentMemory = _currentMemory.copyWith(
                  partnerReaction: reactionName,
                  partnerReactionNote: noteController.text.trim().isEmpty
                      ? 'Telah memeluk kenangan ini dengan cinta.'
                      : noteController.text.trim(),
                );
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$emoji Reaksi hangat berhasil dikirim!'),
                    backgroundColor: EvoriaColors.lightTerracotta,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: EvoriaColors.lightTerracotta,
            ),
            child: const Text('Kirim Reaksi', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? EvoriaColors.darkSurface
            : EvoriaColors.lightCards,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Hapus Kenangan?'),
        content: const Text(
          'Apakah kamu yakin ingin melepaskan kenangan ini dari Suaka? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(memoriesProvider.notifier).deleteMemory(_currentMemory.id);
              if (mounted) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Kenangan telah dilepas dari Suaka.'),
                  ),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
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

    final hasLocalImage = _currentMemory.imagePath != null &&
        File(_currentMemory.imagePath!).existsSync();

    return Scaffold(
      backgroundColor: isDark
          ? EvoriaColors.darkBackground
          : EvoriaColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // App Bar with Photo / Header
          SliverAppBar(
            expandedHeight: hasLocalImage ? 340 : 200,
            pinned: true,
            backgroundColor: isDark
                ? EvoriaColors.darkBackground
                : EvoriaColors.lightBackground,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _currentMemory.isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: _currentMemory.isFavorite ? Colors.redAccent : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () async {
                  await ref
                      .read(memoriesProvider.notifier)
                      .toggleFavorite(_currentMemory.id);
                  setState(() {
                    _currentMemory = _currentMemory.copyWith(
                      isFavorite: !_currentMemory.isFavorite,
                    );
                  });
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 20),
                ),
                onPressed: _confirmDelete,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: hasLocalImage
                  ? Image.file(
                      File(_currentMemory.imagePath!),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF453028), const Color(0xFF272323)]
                              : [const Color(0xFFF3DEC8), const Color(0xFFEAD4BF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.photo_library_outlined,
                          size: 64,
                          color: (isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta)
                              .withOpacity(0.5),
                        ),
                      ),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mood Tag & Date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: (isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta)
                              .withOpacity(0.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _currentMemory.mood,
                          style: TextStyle(
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.calendar_today_rounded, size: 14, color: mutedColor),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('d MMMM yyyy', 'id_ID').format(_currentMemory.date),
                        style: TextStyle(color: mutedColor, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    _currentMemory.title,
                    style: EvoriaTypography.editorialHeadline(
                      color: textColor,
                      fontSize: 26,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: mutedColor),
                      const SizedBox(width: 6),
                      Text(
                        _currentMemory.location,
                        style: TextStyle(
                          color: mutedColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // Narrative Note
                  Text(
                    _currentMemory.note.isEmpty
                        ? 'Tidak ada catatan tertulis untuk momen ini, hanya rasa yang tertinggal dalam diam.'
                        : _currentMemory.note,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      height: 1.7,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Partner Reaction Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Reaksi Jiwa Pasangan',
                              style: EvoriaTypography.editorialHeadline(
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (_currentMemory.partnerReaction != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (isDark
                                      ? EvoriaColors.darkAccent
                                      : EvoriaColors.lightTerracotta)
                                  .withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('💬', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _currentMemory.partnerReactionNote ?? 'Peluk hangat untukmu.',
                                    style: TextStyle(
                                      color: textColor,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                        ] else ...[
                          Text(
                            'Belum ada reaksi yang dikirimkan. Ketuk salah satu perasaan di bawah untuk merespons memori ini:',
                            style: TextStyle(color: mutedColor, fontSize: 13),
                          ),
                          const SizedBox(height: 14),
                        ],

                        // Quick Reaction Buttons
                        Wrap(
                          spacing: 8,
                          children: [
                            ActionChip(
                              label: const Text('💖 Peluk Erat'),
                              onPressed: () => _sendReaction('💖', 'love'),
                            ),
                            ActionChip(
                              label: const Text('☕ Hangat'),
                              onPressed: () => _sendReaction('☕', 'warmth'),
                            ),
                            ActionChip(
                              label: const Text('🌙 Rindu'),
                              onPressed: () => _sendReaction('🌙', 'miss_you'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
