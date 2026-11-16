import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/sanctuary_providers.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';

class TambahKenanganScreen extends ConsumerStatefulWidget {
  const TambahKenanganScreen({super.key});

  @override
  ConsumerState<TambahKenanganScreen> createState() => _TambahKenanganScreenState();
}

class _TambahKenanganScreenState extends ConsumerState<TambahKenanganScreen> {
  final _titleController = TextEditingController();
  final _storyController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedMood = 'Hangat';
  File? _selectedImage;
  bool _isSaving = false;

  final List<Map<String, String>> _moods = [
    {'label': 'Bahagia', 'emoji': '🌸'},
    {'label': 'Hangat', 'emoji': '☕'},
    {'label': 'Tenang', 'emoji': '🌿'},
    {'label': 'Rindu', 'emoji': '🌙'},
    {'label': 'Romantis', 'emoji': '💖'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _storyController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 88,
      );
      if (picked != null) {
        setState(() {
          _selectedImage = File(picked.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih foto: $e'),
            backgroundColor: EvoriaColors.lightTerracotta,
          ),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
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
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveMemory() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap beri judul untuk kenangan ini.'),
          backgroundColor: EvoriaColors.lightTerracotta,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    await ref.read(memoriesProvider.notifier).addMemory(
      title: _titleController.text.trim(),
      date: _selectedDate,
      location: _locationController.text.trim().isEmpty
          ? 'Tempat Kita Berada'
          : _locationController.text.trim(),
      note: _storyController.text.trim(),
      mood: _selectedMood,
      imagePath: _selectedImage?.path,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.auto_awesome, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Kenangan indah berhasil disimpan ke Suaka ✨'),
            ],
          ),
          backgroundColor: EvoriaColors.lightTerracotta,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
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
      backgroundColor: isDark
          ? EvoriaColors.darkBackground
          : EvoriaColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Tambah Kenangan',
          style: EvoriaTypography.editorialHeadline(
            color: textColor,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textColor, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Picker Box
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: isDark
                      ? EvoriaColors.darkSurface
                      : EvoriaColors.lightCards,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (ctx) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Pilih Sumber Foto',
                            style: EvoriaTypography.editorialHeadline(
                              color: textColor,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ListTile(
                            leading: Icon(Icons.photo_library_rounded, color: textColor),
                            title: Text('Galeri HP', style: TextStyle(color: textColor)),
                            onTap: () {
                              Navigator.pop(ctx);
                              _pickImage(ImageSource.gallery);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.camera_alt_rounded, color: textColor),
                            title: Text('Ambil dari Kamera', style: TextStyle(color: textColor)),
                            onTap: () {
                              Navigator.pop(ctx);
                              _pickImage(ImageSource.camera);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: (isDark
                            ? EvoriaColors.glassBorderDark
                            : EvoriaColors.glassBorderLight)
                        .withOpacity(0.5),
                  ),
                ),
                child: _selectedImage != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
                                onPressed: () => _pickImage(ImageSource.gallery),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 48,
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Pilih Foto dari Galeri HP',
                            style: EvoriaTypography.uiBody(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ketuk di sini untuk menyematkan foto abadi',
                            style: EvoriaTypography.uiCaption(color: mutedColor),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Judul Kenangan
            Text(
              'Judul Kenangan',
              style: EvoriaTypography.uiCaption(
                color: mutedColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: TextStyle(color: textColor, fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Misal: Kopi Pagi Pertama Bersamamu',
                hintStyle: TextStyle(color: mutedColor.withOpacity(0.6)),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tanggal & Lokasi Row
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal',
                        style: EvoriaTypography.uiCaption(
                          color: mutedColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 18,
                                color: isDark
                                    ? EvoriaColors.darkAccent
                                    : EvoriaColors.lightTerracotta,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  DateFormat('d MMMM yyyy', 'id_ID').format(_selectedDate),
                                  style: TextStyle(color: textColor, fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lokasi',
                        style: EvoriaTypography.uiCaption(
                          color: mutedColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _locationController,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Misal: Bandung',
                          hintStyle: TextStyle(color: mutedColor.withOpacity(0.6), fontSize: 13),
                          filled: true,
                          fillColor: cardColor,
                          prefixIcon: Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Mood Tags
            Text(
              'Suasana Hati (Mood)',
              style: EvoriaTypography.uiCaption(
                color: mutedColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _moods.map((m) {
                final isSelected = _selectedMood == m['label'];
                return ChoiceChip(
                  label: Text('${m['emoji']} ${m['label']}'),
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
                      setState(() => _selectedMood = m['label']!);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Kisah Emosional / Memoar
            Text(
              'Cerita & Renungan Hari Itu',
              style: EvoriaTypography.uiCaption(
                color: mutedColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _storyController,
              maxLines: 5,
              style: TextStyle(color: textColor, fontSize: 14, height: 1.5),
              decoration: InputDecoration(
                hintText:
                    'Tuliskan bisikan hati, apa yang kau rasakan, tatapan matanya, atau kehangatan kecil yang tak ingin kau lupakan...',
                hintStyle: TextStyle(color: mutedColor.withOpacity(0.6), height: 1.4),
                filled: true,
                fillColor: cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 36),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveMemory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? EvoriaColors.darkAccent
                      : EvoriaColors.lightTerracotta,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.bookmark_added_rounded, color: Colors.white, size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Simpan ke Suaka Abadi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
