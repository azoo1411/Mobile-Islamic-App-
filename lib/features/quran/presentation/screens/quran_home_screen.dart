import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../providers/quran_provider.dart';

class QuranHomeScreen extends ConsumerStatefulWidget {
  const QuranHomeScreen({super.key});

  @override
  ConsumerState<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends ConsumerState<QuranHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('القرآن الكريم'),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu_book_outlined),
              tooltip: 'قراءة المصحف',
              onPressed: () => context.push('/quran/mushaf'),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.push('/quran/search'),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.gold,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            tabs: const [
              Tab(text: 'السور'),
              Tab(text: 'الأجزاء'),
              Tab(text: 'المفضلة'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            _SurahListTab(),
            _JuzListTab(),
            _BookmarksTab(),
          ],
        ),
      ),
    );
  }
}

class _SurahListTab extends ConsumerWidget {
  const _SurahListTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);

    return surahsAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      error: (e, _) => Center(child: Text('خطأ: $e')),
      data: (surahs) => ListView.separated(
        itemCount: surahs.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final s = surahs[index];
          return ListTile(
            onTap: () => context.push('/quran/surah/${s.number}'),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  ArabicUtils.toArabicNumerals(s.number),
                  style: const TextStyle(
                    fontFamily: 'AmiriQuran',
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            title: Text(
              s.nameArabic,
              style: AppTypography.surahName.copyWith(fontSize: 18),
              textDirection: TextDirection.rtl,
            ),
            subtitle: Text(
              '${s.revelationType == 'meccan' ? 'مكية' : 'مدنية'} · ${ArabicUtils.toArabicNumerals(s.ayahCount)} آية',
              style: AppTypography.caption,
              textDirection: TextDirection.rtl,
            ),
            trailing: const Icon(
              Icons.chevron_left,
              color: AppColors.textSecondary,
            ),
          );
        },
      ),
    );
  }
}

class _JuzListTab extends StatelessWidget {
  const _JuzListTab();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
        final juz = index + 1;
        return ListTile(
          onTap: () {},
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                ArabicUtils.toArabicNumerals(juz),
                style: const TextStyle(
                  fontFamily: 'AmiriQuran',
                  fontSize: 14,
                  color: AppColors.gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          title: Text(
            'الجزء ${ArabicUtils.toArabicNumerals(juz)}',
            style: AppTypography.heading3,
            textDirection: TextDirection.rtl,
          ),
        );
      },
    );
  }
}

class _BookmarksTab extends StatelessWidget {
  const _BookmarksTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'لا توجد إشارات مرجعية بعد',
        style: AppTypography.body,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
