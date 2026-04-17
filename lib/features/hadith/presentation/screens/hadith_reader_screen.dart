import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../../core/widgets/arabic_text.dart';
import '../providers/hadith_provider.dart';

class HadithReaderScreen extends ConsumerWidget {
  final String bookId;
  final int hadithId;

  const HadithReaderScreen({
    super.key,
    required this.bookId,
    required this.hadithId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hadithAsync = ref.watch(hadithDetailProvider((bookId, hadithId)));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الحديث'),
          leading: const BackButton(),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {},
            ),
          ],
        ),
        body: hadithAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (hadith) => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildHadithNumber(hadith),
                const SizedBox(height: 20),
                _buildHadithBody(context, hadith),
                const SizedBox(height: 16),
                _buildNarratorChain(hadith),
                const SizedBox(height: 16),
                _buildGrade(hadith),
                const SizedBox(height: 24),
                _buildActions(context, hadith),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHadithNumber(dynamic hadith) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'حديث رقم ${ArabicUtils.toArabicNumerals(hadith.hadithNumber)}',
            style: const TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHadithBody(BuildContext context, dynamic hadith) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.15)),
      ),
      child: HadithText(hadith.textArabic),
    );
  }

  Widget _buildNarratorChain(dynamic hadith) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            'الراوي: ${hadith.narrator}',
            style: AppTypography.bodySmall.copyWith(
              fontStyle: FontStyle.italic,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }

  Widget _buildGrade(dynamic hadith) {
    if (hadith.grade == null) return const SizedBox.shrink();
    final isAuthentic = hadith.grade!.contains('صحيح');
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: (isAuthentic ? AppColors.success : AppColors.gold)
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (isAuthentic ? AppColors.success : AppColors.gold)
                  .withOpacity(0.3),
            ),
          ),
          child: Text(
            hadith.grade!,
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 13,
              color: isAuthentic ? AppColors.success : AppColors.gold,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, dynamic hadith) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: hadith.textArabic));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم النسخ',
                      textDirection: TextDirection.rtl),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('نسخ الحديث'),
            style: OutlinedButton.styleFrom(
              textStyle: const TextStyle(fontFamily: 'NotoNaskhArabic'),
            ),
          ),
        ),
      ],
    );
  }
}
