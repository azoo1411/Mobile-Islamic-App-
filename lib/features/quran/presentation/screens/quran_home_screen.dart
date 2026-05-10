import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../../database/app_database.dart';
import '../providers/bookmarks_provider.dart';
import '../providers/quran_provider.dart';
import 'mushaf_screen.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────

const _navy     = Color(0xFF080D1A);
const _navyCard = Color(0xFF0F1629);
const _navyEle  = Color(0xFF17203A);
const _gold     = Color(0xFFD4AF37);
const _goldDim  = Color(0x33D4AF37);
const _white     = Colors.white;
const _white60   = Color(0x99FFFFFF);
const _white30   = Color(0x4DFFFFFF);

// ─── Last-read provider ───────────────────────────────────────────────────────

final _lastReadProvider = FutureProvider<int?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final p = prefs.getInt(AppConstants.prefLastMushafPage);
  return (p != null && p > 1) ? p : null;
});

// ─── Screen ───────────────────────────────────────────────────────────────────

class QuranHomeScreen extends ConsumerStatefulWidget {
  const QuranHomeScreen({super.key});

  @override
  ConsumerState<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends ConsumerState<QuranHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _search = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _navy,
        body: SafeArea(
          child: Column(
            children: [
              _Header(onSearchTap: () => context.push('/quran/search')),
              _ContinueReadingBanner(),
              _SearchBar(
                controller: _search,
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
              _TabRow(controller: _tab),
              Expanded(
                child: TabBarView(
                  controller: _tab,
                  children: [
                    _SurahTab(query: _query),
                    _JuzTab(),
                    _BookmarksTabNew(),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Gold Mushaf FAB
        floatingActionButton: _MushafFab(),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final VoidCallback onSearchTap;
  const _Header({required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          // Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _goldDim,
              border: Border.all(color: _gold.withOpacity(0.5), width: 1),
            ),
            child: const Center(
              child: Text('☽', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'القرآن الكريم',
                  style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _white,
                  ),
                ),
                Text(
                  'The Holy Quran',
                  style: TextStyle(fontSize: 11, color: _white60, height: 1.2),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded, color: _white60, size: 22),
            onPressed: onSearchTap,
          ),
        ],
      ),
    );
  }
}

// ─── Continue reading banner ──────────────────────────────────────────────────

class _ContinueReadingBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastRead = ref.watch(_lastReadProvider);

    return lastRead.when(
      data: (page) {
        if (page == null) return const SizedBox.shrink();
        return GestureDetector(
          onTap: () => context.push('/quran/mushaf?page=$page'),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [_gold.withOpacity(0.15), _gold.withOpacity(0.05)],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              border: Border.all(color: _gold.withOpacity(0.35), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_stories_outlined, color: _gold, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'متابعة القراءة — صفحة ${ArabicUtils.toArabicNumerals(page)}',
                    style: const TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 14,
                      color: _gold,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const Icon(Icons.chevron_left, color: _gold, size: 18),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

// ─── Search bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          fontFamily: 'NotoNaskhArabic',
          color: _white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'ابحث عن سورة...',
          hintStyle: const TextStyle(
            fontFamily: 'NotoNaskhArabic',
            color: _white30,
            fontSize: 14,
          ),
          prefixIcon: const Icon(Icons.search, color: _white30, size: 20),
          filled: true,
          fillColor: _navyEle,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ─── Tab row ──────────────────────────────────────────────────────────────────

class _TabRow extends StatelessWidget {
  final TabController controller;
  const _TabRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      labelColor: _gold,
      unselectedLabelColor: _white60,
      indicatorColor: _gold,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 2,
      dividerColor: _navyEle,
      labelStyle: const TextStyle(
        fontFamily: 'NotoNaskhArabic',
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'NotoNaskhArabic',
        fontSize: 14,
      ),
      tabs: const [
        Tab(text: 'السور'),
        Tab(text: 'الأجزاء'),
        Tab(text: 'المفضلة'),
      ],
    );
  }
}

// ─── Surah tab ────────────────────────────────────────────────────────────────

class _SurahTab extends ConsumerWidget {
  final String query;
  const _SurahTab({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);

    return surahsAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: _gold, strokeWidth: 2)),
      error: (e, _) => Center(
          child: Text('$e', style: const TextStyle(color: _white60))),
      data: (surahs) {
        final filtered = query.isEmpty
            ? surahs
            : surahs
                .where((s) =>
                    s.nameArabic.contains(query) ||
                    s.nameTransliteration
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .toList();

        return ListView.builder(
          padding: const EdgeInsets.only(top: 4, bottom: 80),
          itemCount: filtered.length,
          itemBuilder: (_, i) => _SurahRow(surah: filtered[i]),
        );
      },
    );
  }
}

class _SurahRow extends StatelessWidget {
  final Surah surah;
  const _SurahRow({required this.surah});

  @override
  Widget build(BuildContext context) {
    final isMeccan = surah.revelationType == 'meccan';
    return InkWell(
      onTap: () => context.push('/quran/surah/${surah.number}'),
      splashColor: _goldDim,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Number badge
            SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.star_outline_rounded,
                      color: _gold.withOpacity(0.6), size: 40),
                  Text(
                    ArabicUtils.toArabicNumerals(surah.number),
                    style: const TextStyle(
                      fontFamily: 'AmiriQuran',
                      fontSize: 12,
                      color: _gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.nameTransliteration,
                    style: const TextStyle(
                        fontSize: 12, color: _white60, height: 1.2),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isMeccan
                              ? _gold.withOpacity(0.12)
                              : Colors.blue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isMeccan ? 'مكية' : 'مدنية',
                          style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 10,
                            color: isMeccan
                                ? _gold
                                : Colors.blue.shade300,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${ArabicUtils.toArabicNumerals(surah.ayahCount)} آية',
                        style: const TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 11,
                            color: _white60),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arabic name
            Text(
              surah.nameArabic,
              style: const TextStyle(
                fontFamily: 'AmiriQuran',
                fontSize: 20,
                color: _white,
                height: 1.5,
              ),
              locale: const Locale('ar'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Juz tab ──────────────────────────────────────────────────────────────────

class _JuzTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: 30,
      itemBuilder: (_, i) {
        final juz = i + 1;
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: _navyCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _white30.withOpacity(0.08), width: 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ArabicUtils.toArabicNumerals(juz),
                  style: const TextStyle(
                    fontFamily: 'AmiriQuran',
                    fontSize: 28,
                    color: _gold,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  'الجزء',
                  style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 12,
                    color: _white60,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Bookmarks tab ────────────────────────────────────────────────────────────

class _BookmarksTabNew extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(mushafBookmarksProvider);

    return bookmarks.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: _gold, strokeWidth: 2)),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bookmark_outline_rounded, size: 48, color: _white30),
                SizedBox(height: 12),
                Text(
                  'لا توجد إشارات مرجعية',
                  style: TextStyle(
                      fontFamily: 'NotoNaskhArabic', color: _white60),
                ),
                SizedBox(height: 4),
                Text(
                  'اضغط 🔖 في المصحف لحفظ صفحة',
                  style: TextStyle(fontSize: 12, color: _white30),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
          itemCount: list.length,
          separatorBuilder: (_, __) =>
              Divider(color: _white.withOpacity(0.06), height: 1),
          itemBuilder: (_, i) {
            final bm = list[i];
            final page = int.tryParse(bm.referenceId) ?? 1;
            final info = ref.watch(mushafPageInfoProvider(page));

            return Dismissible(
              key: ValueKey(bm.id),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red.shade800,
                child: const Icon(Icons.delete_outline, color: _white),
              ),
              onDismissed: (_) => ref
                  .read(appDatabaseProvider)
                  .bookmarksDao
                  .removeBookmark('mushaf_page', bm.referenceId),
              child: ListTile(
                onTap: () => context.push('/quran/mushaf?page=$page'),
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                leading: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _goldDim,
                    border:
                        Border.all(color: _gold.withOpacity(0.4), width: 1),
                  ),
                  child: Center(
                    child: Text(
                      ArabicUtils.toArabicNumerals(page),
                      style: const TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontSize: 14,
                        color: _gold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                title: info.when(
                  data: (d) => Text(
                    d?.surahName ?? 'صفحة $page',
                    style: const TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      color: _white,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  loading: () => Text(
                    'صفحة ${ArabicUtils.toArabicNumerals(page)}',
                    style:
                        const TextStyle(fontFamily: 'NotoNaskhArabic', color: _white),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                subtitle: info.when(
                  data: (d) => d == null
                      ? null
                      : Text(
                          'الجزء ${ArabicUtils.toArabicNumerals(d.juzNumber)}',
                          style: const TextStyle(
                              fontFamily: 'NotoNaskhArabic',
                              color: _white60,
                              fontSize: 12),
                          textDirection: TextDirection.rtl,
                        ),
                  loading: () => null,
                  error: (_, __) => null,
                ),
                trailing:
                    const Icon(Icons.chevron_left, color: _white30, size: 18),
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Mushaf FAB ───────────────────────────────────────────────────────────────

class _MushafFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/quran/mushaf'),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [Color(0xFFD4AF37), Color(0xFFF0C84A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _gold.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded, color: _navy, size: 20),
            SizedBox(width: 8),
            Text(
              'فتح المصحف',
              style: TextStyle(
                fontFamily: 'NotoNaskhArabic',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
