import 'package:flutter/material.dart';
import '../theme/app_typography.dart';

/// Widget for Quran ayah text — enforces Amiri Quran font and RTL
class AyahText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final Color? color;
  final TextAlign textAlign;

  const AyahText(
    this.text, {
    super.key,
    this.fontSize,
    this.color,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        text,
        style: AppTypography.quranAyah.copyWith(
          fontSize: fontSize,
          color: color,
        ),
        textAlign: textAlign,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}

/// Widget for regular Arabic UI text
class ArabicText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ArabicText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? AppTypography.body,
      textAlign: textAlign ?? TextAlign.right,
      textDirection: TextDirection.rtl,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Hadith body text widget
class HadithText extends StatelessWidget {
  final String text;
  final double? fontSize;

  const HadithText(this.text, {super.key, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.hadithText.copyWith(fontSize: fontSize),
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
    );
  }
}

/// Poetry text widget
class PoetryText extends StatelessWidget {
  final String text;

  const PoetryText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.poetryText,
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
  }
}
