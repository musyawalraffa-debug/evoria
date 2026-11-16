import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/theme/evoria_shadows.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Raffa');
  DateTime? _anniversaryDate = DateTime(2025, 9, 14);

  @override
  void dispose() {
    _nameController.dispose();
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
      backgroundColor: isDark
          ? EvoriaColors.darkBackground
          : EvoriaColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profil Pertama',
          style: EvoriaTypography.editorialHeadline(
            color: textColor,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sentuhan Pertama di Suaka',
                style: EvoriaTypography.editorialTitle(
                  color: textColor,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Bagikan namamu dan tanggal bersejarah awal mula kisah kalian berdua.',
                style: EvoriaTypography.uiBody(
                  color: mutedColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),

              // Avatar Circle
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: (isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta)
                            .withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _nameController.text.isNotEmpty
                              ? _nameController.text[0].toUpperCase()
                              : 'E',
                          style: EvoriaTypography.editorialTitle(
                            color: isDark
                                ? EvoriaColors.darkAccent
                                : EvoriaColors.lightTerracotta,
                            fontSize: 36,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? EvoriaColors.darkAccent
                              : EvoriaColors.lightTerracotta,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Name Field
              Text(
                'Nama Panggilanmu',
                style: EvoriaTypography.uiCaption(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  controller: _nameController,
                  style: TextStyle(color: textColor, fontSize: 15),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Masukkan nama panggilan',
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Anniversary Date Picker
              Text(
                'Tanggal Bersejarah Bersama (Opsional)',
                style: EvoriaTypography.uiCaption(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _anniversaryDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _anniversaryDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _anniversaryDate != null
                            ? '${_anniversaryDate!.day} / ${_anniversaryDate!.month} / ${_anniversaryDate!.year}'
                            : 'Pilih tanggal mulai bersama',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14.5,
                        ),
                      ),
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 20,
                        color: isDark
                            ? EvoriaColors.darkAccent
                            : EvoriaColors.lightTerracotta,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Enter Sanctuary Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/beranda');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? EvoriaColors.darkAccent
                        : EvoriaColors.lightTerracotta,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Masuk ke Suaka Bersama',
                    style: EvoriaTypography.uiButton(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
