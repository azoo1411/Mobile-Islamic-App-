import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../providers/hadith_provider.dart';

class HadithChapterScreen extends ConsumerWidget {
  final String bookId;

  const HadithChapterScreen({super.key, required this.bookId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(hadithChaptersProvider(bookId));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_bookName(bookId)),
          leading: const BackButton(),
        ),
        body: chaptersAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (chapters) => ListView.separated(
            itemCount: chapters.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, indent: 16, endIndent: 16),
            itemBuilder: (context, index) {
              final ch = chapters[index];
              return ListTile(
                onTap: () => context
                    .push('/hadith/$bookId/hadith/${ch.id}'),
                title: Text(
                  ch.titleArabic,
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                subtitle: Text(
                  '${ArabicUtils.toArabicNumerals(ch.hadithCount)} حديث',
                  style: AppTypography.caption,
                  textDirection: TextDirection.rtl,
                ),
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      ArabicUtils.toArabicNumerals(ch.chapterNumber),
                      style: const TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                trailing: const Icon(Icons.chevron_left,
                    color: AppColors.textSecondary),
              );
            },
          ),
        ),
      ),
    );
  }

  String _bookName(String id) {
    const names = {
      'bukhari': 'صحيح البخاري',
      'muslim': 'صحيح مسلم',
      'abudawud': 'سنن أبي داود',
      'tirmidhi': 'جامع الترمذي',
    };
    return names[id] ?? id;
  }
}
