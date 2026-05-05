import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../../database/app_database.dart';
import '../providers/quran_provider.dart';

class QuranSearchScreen extends ConsumerStatefulWidget {
  const QuranSearchScreen({super.key});

  @override
  ConsumerState<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends ConsumerState<QuranSearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahsAsync = _query.length >= 2 ? ref.watch(surahSearchProvider(_query)) : null;
    final ayahsAsync = _query.length >= 2 ? ref.watch(quranSearchProvider(_query)) : null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _controller,
            autofocus: true,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 16,
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              hintText: 'ابحث عن سورة أو آية...',
              hintStyle: TextStyle(color: Colors.white60),
              border: InputBorder.none,
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          leading: const BackButton(),
          actions: [
            if (_query.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  setState(() => _query = '');
                },
              ),
          ],
        ),
        body: _buildBody(surahsAsync, ayahsAsync),
      ),
    );
  }

  Widget _buildBody(AsyncValue? surahsAsync, AsyncValue? ayahsAsync) {
    if (_query.length < 2) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text('ابحث عن سورة أو آية', style: AppTypography.bodySmall),
          ],
        ),
      );
    }

    if (surahsAsync == null && ayahsAsync == null) return const SizedBox();

    final surahData = surahsAsync?.valueOrNull as List<dynamic>? ?? [];
    final ayahData = ayahsAsync?.valueOrNull as List<dynamic>? ?? [];
    final isLoading = (surahsAsync?.isLoading ?? false) || (ayahsAsync?.isLoading ?? false);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (surahData.isEmpty && ayahData.isEmpty) {
      return Center(
        child: Text('لا توجد نتائج لـ "$_query"', style: AppTypography.body),
      );
    }

    return ListView(
      children: [
        if (surahData.isNotEmpty) ...[
          _sectionHeader('السور', surahData.length),
          ...surahData.map((s) {
            final surah = s as Surah;
            return ListTile(
              onTap: () => context.push('/quran/surah/${surah.number}'),
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    ArabicUtils.toArabicNumerals(surah.number),
                    style: const TextStyle(
                      fontFamily: 'AmiriQuran',
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              title: Text(surah.nameArabic,
                  style: AppTypography.heading3, textDirection: TextDirection.rtl),
              subtitle: Text(
                '${surah.revelationType == 'meccan' ? 'مكية' : 'مدنية'} · ${ArabicUtils.toArabicNumerals(surah.ayahCount)} آية',
                style: AppTypography.caption,
                textDirection: TextDirection.rtl,
              ),
              trailing: const Icon(Icons.chevron_left, color: AppColors.textSecondary),
            );
          }),
          const Divider(height: 1),
        ],
        if (ayahData.isNotEmpty) ...[
          _sectionHeader('الآيات', ayahData.length),
          ...ayahData.map((a) {
            final ayah = a as Ayah;
            return ListTile(
              onTap: () => context.push(
                  '/quran/surah/${ayah.surahNumber}?ayah=${ayah.ayahNumber}'),
              title: Text(
                ayah.textArabic,
                style: AppTypography.quranAyah.copyWith(fontSize: 16),
                textDirection: TextDirection.rtl,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                'سورة ${ArabicUtils.toArabicNumerals(ayah.surahNumber)} · آية ${ArabicUtils.toArabicNumerals(ayah.ayahNumber)}',
                style: AppTypography.caption,
                textDirection: TextDirection.rtl,
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _sectionHeader(String title, int count) {
    return Container(
      color: AppColors.primary.withOpacity(0.07),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        '$title (${ArabicUtils.toArabicNumerals(count)})',
        style: AppTypography.caption.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
