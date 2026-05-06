import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

class HajjUmrahHubScreen extends StatelessWidget {
  const HajjUmrahHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF080F1C), Color(0xFF0F1E38), Color(0xFF080F1C)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // AppBar row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white60, size: 20),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    child: Column(
                      children: [
                        // Hero
                        const SizedBox(height: 8),
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF12243A),
                            border: Border.all(
                              color: AppColors.gold.withOpacity(0.4),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gold.withOpacity(0.15),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text('🕋', style: TextStyle(fontSize: 62)),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        const Text(
                          'الحج والعمرة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Hajj & Umrah Guide',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.35),
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'اختر دليلك الروحي',
                          style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 14,
                            color: AppColors.gold.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Hajj card
                        _GuideCard(
                          emoji: '🕋',
                          titleArabic: 'مناسك الحج',
                          titleEnglish: 'Hajj Rituals',
                          subtitle: '٩ مناسك — من الإحرام حتى السعي',
                          primaryColor: const Color(0xFF0E2418),
                          accentColor: const Color(0xFF52B788),
                          onTap: () => context.push('/hajj/guide'),
                        ),
                        const SizedBox(height: 16),

                        // Umrah card
                        _GuideCard(
                          emoji: '🕌',
                          titleArabic: 'مناسك العمرة',
                          titleEnglish: 'Umrah Rituals',
                          subtitle: '٤ مناسك — من الإحرام حتى التحلل',
                          primaryColor: const Color(0xFF0E1A30),
                          accentColor: const Color(0xFFD4AF37),
                          onTap: () => context.push('/umrah'),
                        ),
                        const SizedBox(height: 32),

                        // Info note
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.07),
                            ),
                          ),
                          child: const Text(
                            'يمكنك تتبع تقدمك وتأشير كل خطوة أنجزتها.\nالمحتوى متاح بالكامل بدون إنترنت.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'NotoNaskhArabic',
                              fontSize: 13,
                              color: Colors.white38,
                              height: 1.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GuideCard extends StatelessWidget {
  final String emoji;
  final String titleArabic;
  final String titleEnglish;
  final String subtitle;
  final Color primaryColor;
  final Color accentColor;
  final VoidCallback onTap;

  const _GuideCard({
    required this.emoji,
    required this.titleArabic,
    required this.titleEnglish,
    required this.subtitle,
    required this.primaryColor,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: accentColor.withOpacity(0.35), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.12),
                border: Border.all(color: accentColor.withOpacity(0.35)),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleArabic,
                    style: const TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 12,
                      color: accentColor.withOpacity(0.85),
                    ),
                  ),
                  Text(
                    titleEnglish,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.3),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.arrow_back_ios,
              color: accentColor.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
