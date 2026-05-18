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

// ─── Design tokens ─────────────────────────────────────────────────────────────
const _cream     = Color(0xFFFAF8F0);
const _parchment = Color(0xFFF0EAD6);
const _ink       = Color(0xFF1A1208);
const _inkMid    = Color(0xFF5C4A2A);
const _inkLight  = Color(0xFFAA9070);
const _gold      = Color(0xFFC8A820);
const _green     = Color(0xFF1B4D3E);

// ─── Surah → first Mushaf page map ────────────────────────────────────────────
const _surahStartPage = <int, int>{
  1:1,2:2,3:50,4:77,5:106,6:128,7:151,8:177,9:187,10:208,
  11:221,12:235,13:249,14:255,15:262,16:267,17:282,18:293,19:305,20:312,
  21:322,22:332,23:342,24:350,25:359,26:367,27:377,28:385,29:396,30:404,
  31:411,32:415,33:418,34:428,35:434,36:440,37:446,38:453,39:458,40:467,
  41:477,42:483,43:489,44:496,45:499,46:502,47:507,48:511,49:515,50:518,
  51:520,52:523,53:526,54:528,55:531,56:534,57:537,58:542,59:545,60:549,
  61:551,62:553,63:554,64:556,65:558,66:560,67:562,68:564,69:566,70:568,
  71:570,72:572,73:574,74:575,75:577,76:578,77:580,78:582,79:583,80:585,
  81:586,82:587,83:587,84:588,85:589,86:590,87:591,88:592,89:593,90:594,
  91:595,92:595,93:596,94:596,95:597,96:597,97:598,98:598,99:599,100:599,
  101:600,102:600,103:601,104:601,105:601,106:602,107:602,108:602,
  109:603,110:603,111:603,112:604,113:604,114:604,
};

// ─── Last-read provider ────────────────────────────────────────────────────────
final _lastReadProvider = FutureProvider<int?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final p = prefs.getInt(AppConstants.prefLastMushafPage);
  return (p != null && p > 1) ? p : null;
});

// ─── Screen ────────────────────────────────────────────────────────────────────
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
        backgroundColor: _cream,
        body: Column(
          children: [
            _QuranHeader(),
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
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
                          _BookmarksTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: _MushafFab(),
      ),
    );
  }
}

// ─── Header ────────────────────────────────────────────────────────────────────
class _QuranHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _green,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Open Mushaf icon
                  InkWell(
                    onTap: () => context.push('/quran/mushaf'),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.menu_book_rounded,
                          color: _gold.withOpacity(0.85), size: 24),
                    ),
                  ),
                  // Title
                  const Text(
                    'القرآن الكريم',
                    style: TextStyle(
                      fontFamily: 'AmiriQuran',
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _gold,
                      height: 1.6,
                    ),
                  ),
                  // Search icon
                  InkWell(
                    onTap: () => context.push('/quran/search'),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(Icons.search_rounded,
                          color: _gold.withOpacity(0.85), size: 24),
                    ),
                  ),
                ],
              ),
            ),
            // Decorative divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(height: 1, color: _gold.withOpacity(0.35)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _gold.withOpacity(0.6),
                    ),
                  ),
                  Expanded(
                    child: Container(height: 1, color: _gold.withOpacity(0.35)),
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

// ─── Continue reading banner ───────────────────────────────────────────────────
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
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            decoration: BoxDecoration(
              color: _green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _green.withOpacity(0.2), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_stories_outlined, color: _green, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'متابعة القراءة — صفحة ${ArabicUtils.toArabicNumerals(page)}',
                    style: const TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 14,
                      color: _green,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Icon(Icons.chevron_left, color: _green.withOpacity(0.6), size: 18),
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

// ─── Search bar ────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          fontFamily: 'NotoNaskhArabic',
          color: _ink,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'ابحث عن سورة...',
          hintStyle: TextStyle(
            fontFamily: 'NotoNaskhArabic',
            color: _inkLight,
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: _inkLight, size: 20),
          filled: true,
          fillColor: _parchment,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: _gold.withOpacity(0.3), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: _gold.withOpacity(0.3), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: _gold.withOpacity(0.7), width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ─── Tab row ───────────────────────────────────────────────────────────────────
class _TabRow extends StatelessWidget {
  final TabController controller;
  const _TabRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _cream,
      child: TabBar(
        controller: controller,
        labelColor: _green,
        unselectedLabelColor: _inkLight,
        indicatorColor: _gold,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2.5,
        dividerColor: _parchment,
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
      ),
    );
  }
}

// ─── Surah tab ─────────────────────────────────────────────────────────────────
class _SurahTab extends ConsumerWidget {
  final String query;
  const _SurahTab({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);
    return surahsAsync.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: _gold, strokeWidth: 2)),
      error: (e, _) =>
          Center(child: Text('$e', style: const TextStyle(color: _inkMid))),
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
          padding: const EdgeInsets.only(top: 4, bottom: 100),
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
      onTap: () {
        final page = _surahStartPage[surah.number] ?? 1;
        context.push('/quran/mushaf?page=$page');
      },
      splashColor: _gold.withOpacity(0.08),
      highlightColor: _gold.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: Row(
          children: [
            // Number badge – octagonal look
            _NumberBadge(number: surah.number),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.nameTransliteration,
                    style: TextStyle(
                        fontSize: 11,
                        color: _inkMid,
                        height: 1.2),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: isMeccan
                              ? _gold.withOpacity(0.12)
                              : _green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isMeccan
                                ? _gold.withOpacity(0.3)
                                : _green.withOpacity(0.25),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          isMeccan ? 'مكية' : 'مدنية',
                          style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 10,
                            color: isMeccan ? _gold : _green,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${ArabicUtils.toArabicNumerals(surah.ayahCount)} آية',
                        style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 11,
                            color: _inkLight),
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
                fontSize: 22,
                color: _ink,
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

// Octagonal number badge inspired by Mushaf ayah markers
class _NumberBadge extends StatelessWidget {
  final int number;
  const _NumberBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: _gold.withOpacity(0.1),
        border: Border.all(color: _gold.withOpacity(0.55), width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          ArabicUtils.toArabicNumerals(number),
          style: const TextStyle(
            fontFamily: 'AmiriQuran',
            fontSize: 13,
            color: _gold,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─── Juz tab ───────────────────────────────────────────────────────────────────
class _JuzTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: 30,
      itemBuilder: (_, i) {
        final juz = i + 1;
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {},
            splashColor: _gold.withOpacity(0.12),
            child: Container(
              decoration: BoxDecoration(
                color: _parchment,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _gold.withOpacity(0.3), width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ArabicUtils.toArabicNumerals(juz),
                    style: const TextStyle(
                      fontFamily: 'AmiriQuran',
                      fontSize: 30,
                      color: _green,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'الجزء',
                    style: TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 11,
                      color: _inkMid,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Bookmarks tab ─────────────────────────────────────────────────────────────
class _BookmarksTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(mushafBookmarksProvider);
    return bookmarks.when(
      loading: () => const Center(
          child: CircularProgressIndicator(color: _gold, strokeWidth: 2)),
      error: (_, __) => const SizedBox.shrink(),
      data: (list) {
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bookmark_outline_rounded,
                    size: 52, color: _inkLight.withOpacity(0.5)),
                const SizedBox(height: 14),
                const Text(
                  'لا توجد إشارات مرجعية',
                  style: TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      color: _inkMid,
                      fontSize: 15),
                ),
                const SizedBox(height: 6),
                Text(
                  'اضغط 🔖 في المصحف لحفظ صفحة',
                  style: TextStyle(fontSize: 12, color: _inkLight),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          itemCount: list.length,
          separatorBuilder: (_, __) =>
              Divider(color: _gold.withOpacity(0.15), height: 1),
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
                color: Colors.red.shade700,
                child: const Icon(Icons.delete_outline, color: Colors.white),
              ),
              onDismissed: (_) => ref
                  .read(appDatabaseProvider)
                  .bookmarksDao
                  .removeBookmark('mushaf_page', bm.referenceId),
              child: ListTile(
                onTap: () => context.push('/quran/mushaf?page=$page'),
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _gold.withOpacity(0.1),
                    border: Border.all(
                        color: _gold.withOpacity(0.45), width: 1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      ArabicUtils.toArabicNumerals(page),
                      style: const TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontSize: 15,
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
                      color: _ink,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  loading: () => Text(
                    'صفحة ${ArabicUtils.toArabicNumerals(page)}',
                    style: const TextStyle(
                        fontFamily: 'NotoNaskhArabic', color: _ink),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                subtitle: info.when(
                  data: (d) => d == null
                      ? null
                      : Text(
                          'الجزء ${ArabicUtils.toArabicNumerals(d.juzNumber)}',
                          style: TextStyle(
                              fontFamily: 'NotoNaskhArabic',
                              color: _inkMid,
                              fontSize: 12),
                          textDirection: TextDirection.rtl,
                        ),
                  loading: () => null,
                  error: (_, __) => null,
                ),
                trailing:
                    Icon(Icons.chevron_left, color: _inkLight, size: 18),
              ),
            );
          },
        );
      },
    );
  }
}

// ─── Mushaf FAB ────────────────────────────────────────────────────────────────
class _MushafFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/quran/mushaf'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: _green,
          border: Border.all(color: _gold.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: _green.withOpacity(0.4),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded, color: _gold, size: 20),
            const SizedBox(width: 8),
            const Text(
              'فتح المصحف',
              style: TextStyle(
                fontFamily: 'NotoNaskhArabic',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: _gold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
