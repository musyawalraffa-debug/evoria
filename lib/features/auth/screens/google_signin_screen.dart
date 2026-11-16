import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/evoria_colors.dart';
import '../../../core/theme/evoria_typography.dart';
import '../../../core/theme/evoria_shadows.dart';

class GoogleSignInScreen extends StatefulWidget {
  const GoogleSignInScreen({super.key});

  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // In production, invokes GoogleSignIn().signIn() and authenticates session
      await Future.delayed(const Duration(milliseconds: 1200));

      if (mounted) {
        context.go('/profile-setup');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal menghubungkan akun Google. Silakan periksa koneksi Anda.';
          _isLoading = false;
        });
      }
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Masuk ke Suaka',
                style: EvoriaTypography.editorialTitle(
                  color: textColor,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Gunakan akun Google Anda untuk mengamankan data dan sinkronisasi kenangan dengan pasangan.',
                style: EvoriaTypography.uiBody(
                  color: mutedColor,
                  fontSize: 14.5,
                ),
              ),
              const Spacer(flex: 1),

              // Visual Sanctuary Security Badge
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                    boxShadow: isDark
                        ? EvoriaShadows.softCardDark
                        : EvoriaShadows.softCardLight,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lock_person_outlined,
                      size: 52,
                      color: isDark
                          ? EvoriaColors.darkAccent
                          : EvoriaColors.lightTerracotta,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Enkripsi Privat Dua Insan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? EvoriaColors.darkAccent
                        : EvoriaColors.lightTerracotta,
                  ),
                ),
              ),
              const Spacer(flex: 2),

              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Google Sign-In Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color(0xFF3B2F2C)
                        : Colors.white,
                    foregroundColor: textColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: (isDark ? Colors.white : Colors.black)
                            .withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isDark
                                  ? EvoriaColors.darkAccent
                                  : EvoriaColors.lightTerracotta,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.account_circle_outlined,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Lanjutkan dengan Google',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 14),

              Text(
                'Dengan masuk, kenangan Anda tersimpan aman secara terenkripsi dan tidak dibagikan kepada pihak manapun.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  color: mutedColor.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
