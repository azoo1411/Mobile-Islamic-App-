import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
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
    final resultsAsync = _query.length >= 3
        ? ref.watch(quranSearchProvider(_query))
        : null;

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
              hintText: 'ابحث في القرآن الكريم...',
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
        body: _buildBody(resultsAsync),
      ),
    );
  }

  Widget _buildBody(AsyncValue? resultsAsync) {
    if (_query.length < 3) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'أدخل ٣ أحرف على الأقل للبحث',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      );
    }

    if (resultsAsync == null) return const SizedBox();

    return resultsAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, _) => Center(child: Text('خطأ: $e')),
      data: (results) {
        if (results.isEmpty) {
          return Center(
            child: Text('لا توجد نتائج لـ "$_query"',
                style: AppTypography.body),
          );
        }
        return ListView.separated(
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final ayah = results[index];
            return ListTile(
              onTap: () => context.push(
                  '/quran/surah/${ayah.surahNumber}?ayah=${ayah.ayahNumber}'),
              title: Text(
                _highlightQuery(ayah.textArabic),
                style: AppTypography.quranAyah.copyWith(fontSize: 16),
                textDirection: TextDirection.rtl,
              ),
              subtitle: Text(
                'سورة ${ArabicUtils.toArabicNumerals(ayah.surahNumber)} · آية ${ArabicUtils.toArabicNumerals(ayah.ayahNumber)}',
                style: AppTypography.caption,
                textDirection: TextDirection.rtl,
              ),
            );
          },
        );
      },
    );
  }

  String _highlightQuery(String text) => text; // Rich text highlighting can be added
}
