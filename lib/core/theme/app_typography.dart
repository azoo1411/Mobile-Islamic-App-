import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String _quranFont = 'AmiriQuran';
  static const String _amiriFont = 'Amiri';
  static const String _uiFont = 'NotoNaskhArabic';

  // Quran Text Styles
  static const TextStyle quranAyah = TextStyle(
    fontFamily: _quranFont,
    fontSize: 22,
    height: 2.2,
    color: AppColors.textQuran,
    letterSpacing: 0,
  );

  static const TextStyle quranAyahLarge = TextStyle(
    fontFamily: _quranFont,
    fontSize: 26,
    height: 2.4,
    color: AppColors.textQuran,
  );

  static const TextStyle surahName = TextStyle(
    fontFamily: _amiriFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle basmala = TextStyle(
    fontFamily: _quranFont,
    fontSize: 28,
    color: AppColors.primary,
    height: 2.0,
  );

  // UI Text Styles
  static const TextStyle heading1 = TextStyle(
    fontFamily: _amiriFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: _uiFont,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: _uiFont,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: _uiFont,
    fontSize: 16,
    height: 1.8,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _uiFont,
    fontSize: 14,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  static const TextStyle hadithText = TextStyle(
    fontFamily: _amiriFont,
    fontSize: 18,
    height: 2.0,
    color: AppColors.textPrimary,
  );

  static const TextStyle poetryText = TextStyle(
    fontFamily: _amiriFont,
    fontSize: 19,
    height: 2.2,
    color: AppColors.textPrimary,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _uiFont,
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle prayerTime = TextStyle(
    fontFamily: _uiFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle arabicNumber = TextStyle(
    fontFamily: _quranFont,
    fontSize: 14,
    color: AppColors.gold,
  );
}
