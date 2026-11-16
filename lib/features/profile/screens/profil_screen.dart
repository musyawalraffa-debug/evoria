import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/sanctuary_providers.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/theme/evoria_shadows.dart';

class ProfilScreen extends ConsumerWidget {
  const ProfilScreen({super.key});

  void _showEditProfileDialog(BuildContext context, WidgetRef ref, ProfileState profile) {
    final userController = TextEditingController(text: profile.userName);
    final partnerController = TextEditingController(text: profile.partnerName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? EvoriaColors.darkSurface
            : EvoriaColors.lightCards,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Ubah Nama Kalian'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'Nama Kamu',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: partnerController,
              decoration: const InputDecoration(
                labelText: 'Nama Pasangan',
                prefixIcon: Icon(Icons.favorite_outline),
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
              if (userController.text.trim().isNotEmpty &&
                  partnerController.text.trim().isNotEmpty) {
                await ref.read(profileProvider.notifier).updateNames(
                      userController.text.trim(),
                      partnerController.text.trim(),
                    );
                if (context.mounted) Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: EvoriaColors.lightTerracotta,
            ),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context, WidgetRef ref, ProfileState profile) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: profile.anniversaryDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: EvoriaColors.lightTerracotta,
              onPrimary: Colors.white,
              onSurface: EvoriaColors.lightInk,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await ref.read(profileProvider.notifier).updateAnniversary(picked);
    }
  }

  void _showGeminiKeyDialog(BuildContext context, WidgetRef ref, ProfileState profile) {
    final keyController = TextEditingController(text: profile.geminiApiKey ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? EvoriaColors.darkSurface
            : EvoriaColors.lightCards,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Google AI Studio API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan API Key Gemini 1.5 Flash dari Google AI Studio untuk mengaktifkan pencarian foto pintar & refleksi harian otomatis:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                hintText: 'AIzaSy...',
                prefixIcon: Icon(Icons.key_rounded),
                border: OutlineInputBorder(),
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
              await ref.read(profileProvider.notifier).updateGeminiKey(keyController.text.trim());
              if (context.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('API Key Google AI Studio berhasil disimpan! ✨'),
                    backgroundColor: EvoriaColors.lightTerracotta,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: EvoriaColors.lightTerracotta,
            ),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildAvatarCircle(
                              profile.userName.isNotEmpty ? profile.userName[0].toUpperCase() : 'U',
                              profile.userName,
                              textColor,
                              mutedColor,
                              isDark,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                Icons.favorite_rounded,
                                color: isDark
                                    ? EvoriaColors.darkAccent
                                    : EvoriaColors.lightTerracotta,
                                size: 28,
                              ),
                            ),
                            _buildAvatarCircle(
                              profile.partnerName.isNotEmpty ? profile.partnerName[0].toUpperCase() : 'P',
                              profile.partnerName,
                              textColor,
                              mutedColor,
                              isDark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          '${profile.userName} & ${profile.partnerName}',
                          style: EvoriaTypography.editorialHeadline(
                            color: textColor,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sejak ${DateFormat("d MMMM yyyy", "id_ID").format(profile.anniversaryDate)}',
                          style: TextStyle(color: mutedColor, fontSize: 13),
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: () => _showEditProfileDialog(context, ref, profile),
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Ubah Nama Pasangan'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                            side: BorderSide(
                              color: (isDark
                                      ? EvoriaColors.darkAccent
                                      : EvoriaColors.lightTerracotta)
                                  .withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sanctuary Settings List
                  Text(
                    'Pengaturan Suaka',
                    style: EvoriaTypography.editorialHeadline(
                      color: textColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tanggal Spesial / Anniversary
                  _buildSettingTile(
                    icon: Icons.calendar_today_rounded,
                    title: 'Tanggal Bersejarah Bersama',
                    subtitle: DateFormat('d MMMM yyyy', 'id_ID').format(profile.anniversaryDate),
                    cardColor: cardColor,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    onTap: () => _showDatePicker(context, ref, profile),
                  ),
                  const SizedBox(height: 10),

                  // Google AI Studio Key
                  _buildSettingTile(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Google AI Studio (Gemini)',
                    subtitle: profile.geminiApiKey != null && profile.geminiApiKey!.isNotEmpty
                        ? 'Kunci AI Terhubung'
                        : 'Belum diatur (Ketuk untuk memasukkan)',
                    cardColor: cardColor,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    onTap: () => _showGeminiKeyDialog(context, ref, profile),
                  ),
                  const SizedBox(height: 10),

                  // Statistik Suaka
                  _buildSettingTile(
                    icon: Icons.data_usage_rounded,
                    title: 'Total Kenangan Tersimpan',
                    subtitle: '${memories.length} Momen Abadi (Tersimpan Lokal di HP)',
                    cardColor: cardColor,
                    textColor: textColor,
                    mutedColor: mutedColor,
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),

                  // Keamanan & Privasi
                  Text(
                    'Privasi & Kedaulatan Data',
                    style: EvoriaTypography.editorialHeadline(
                      color: textColor,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          color: isDark
                              ? EvoriaColors.darkAccent
                              : EvoriaColors.lightTerracotta,
                          size: 24,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Data Sepenuhnya Milik Kalian',
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Semua foto dan catatan kenangan disimpan langsung di memori perangkat HP Anda secara lokal. Tidak ada server pihak ketiga yang mengintip memori cinta kalian.',
                                style: TextStyle(
                                  color: mutedColor,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarCircle(
    String letter,
    String name,
    Color textColor,
    Color mutedColor,
    bool isDark,
  ) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: (isDark
                    ? EvoriaColors.darkAccent
                    : EvoriaColors.lightTerracotta)
                .withOpacity(0.18),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? EvoriaColors.darkAccent
                  : EvoriaColors.lightTerracotta,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                color: isDark
                    ? EvoriaColors.darkAccent
                    : EvoriaColors.lightTerracotta,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color cardColor,
    required Color textColor,
    required Color mutedColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: textColor),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: mutedColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14, color: mutedColor.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}
