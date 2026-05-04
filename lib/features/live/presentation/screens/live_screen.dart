import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class LiveScreen extends StatelessWidget {
  const LiveScreen({super.key});

  // YouTube channel live stream URLs
  static const _makkahUrl =
      'https://www.youtube.com/@QuranWebtv/live';
  static const _madinahUrl =
      'https://www.youtube.com/@sunnahchannel/live';

  static const _streams = [
    _StreamInfo(
      title: 'الحرم المكي',
      subtitle: 'قناة القرآن الكريم',
      description: 'بث مباشر على مدار الساعة من المسجد الحرام في مكة المكرمة',
      icon: Icons.mosque,
      color: Color(0xFF1A6B3A),
      url: _makkahUrl,
    ),
    _StreamInfo(
      title: 'المسجد النبوي',
      subtitle: 'قناة السنة النبوية',
      description: 'بث مباشر على مدار الساعة من المسجد النبوي الشريف في المدينة المنورة',
      icon: Icons.star_outline,
      color: Color(0xFF2C4A8E),
      url: _madinahUrl,
    ),
  ];

  Future<void> _openStream(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تعذّر فتح الرابط. تأكد من تثبيت تطبيق YouTube.',
            style: TextStyle(fontFamily: 'NotoNaskhArabic'),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'البث المباشر',
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'بث مباشر ٢٤/٧',
                          style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 13,
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'الحرمين الشريفين',
                      style: AppTypography.heading2.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'اضغط لمشاهدة البث في تطبيق YouTube',
                      style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stream cards
              ...(_streams.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _StreamCard(
                      stream: s,
                      onTap: () => _openStream(context, s.url),
                    ),
                  ))),

              const SizedBox(height: 8),
              Center(
                child: Text(
                  'البث يُفتح في تطبيق YouTube',
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreamCard extends StatelessWidget {
  final _StreamInfo stream;
  final VoidCallback onTap;
  const _StreamCard({required this.stream, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: stream.color.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image banner
            Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [stream.color, stream.color.withValues(alpha: 0.7)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(stream.icon, color: Colors.white.withValues(alpha: 0.2), size: 100),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF4444),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle, color: Colors.white, size: 8),
                                  SizedBox(width: 4),
                                  Text(
                                    'مباشر',
                                    style: TextStyle(
                                      fontFamily: 'NotoNaskhArabic',
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stream.title,
                              style: const TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              stream.subtitle,
                              style: const TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom action
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      stream.description,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: stream.color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.play_circle_fill, color: stream.color, size: 32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreamInfo {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final String url;
  const _StreamInfo({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.url,
  });
}
