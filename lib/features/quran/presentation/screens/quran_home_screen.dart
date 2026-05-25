import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/arabic_utils.dart';
import '../providers/quran_provider.dart';

// ─── Design tokens ──────────────────────────────────────────────────────────────
const _cream      = Color(0xFFF8F4E9);
const _parchment  = Color(0xFFFFFDF5);
const _ink        = Color(0xFF1A1A2E);
const _inkMid     = Color(0xFF4A4A6A);
const _inkLight   = Color(0xFF9090AA);
const _gold       = Color(0xFFD4AF37);
const _green      = Color(0xFF1B4332);
const _greenDeep  = Color(0xFF0D2B1F);

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
        backgroundColor: _cream,
        body: Column(
          children: [
            _QuranHeader(),
            Expanded(
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
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
      ),
    );
  }
}

class _QuranHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_greenDeep, _green],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HeaderIconBtn(icon: Icons.menu_book_rounded, onTap: () {}),
                  const Text(
                    'القرآن الكريم',
                    style: TextStyle(
                      fontFamily: 'AmiriQuran',
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: _gold,
                      height: 1.5,
                    ),
                  ),
                  _HeaderIconBtn(
                    icon: Icons.search_rounded,
                    onTap: () => context.push('/quran/search'),
                  ),
                ],
              ),
            ),
            const _OrnamentDivider(),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _HeaderIconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _gold.withOpacity(0.22), width: 1),
        ),
        child: Icon(icon, color: _gold.withOpacity(0.85), size: 20),
      ),
    );
  }
}

class _OrnamentDivider extends StatelessWidget {
  const _OrnamentDivider();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          Expanded(child: Container(height: 0.8, color: _gold.withOpacity(0.3))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              _dot(3.5, 0.35), const SizedBox(width: 5),
              _dot(5.5, 0.65), const SizedBox(width: 5),
              _dot(3.5, 0.35),
            ]),
          ),
          Expanded(child: Container(height: 0.8, color: _gold.withOpacity(0.3))),
        ],
      ),
    );
  }
  Widget _dot(double size, double opacity) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: _gold.withOpacity(opacity)),
  );
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.controller, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: _ink.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontFamily: 'NotoNaskhArabic', color: _ink, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'ابحث عن سورة...',
            hintStyle: TextStyle(fontFamily: 'NotoNaskhArabic', color: _inkLight, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: _inkLight.withOpacity(0.7), size: 20),
            filled: true,
            fillColor: _parchment,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: _gold.withOpacity(0.25), width: 1)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: _gold.withOpacity(0.6), width: 1.5)),
          ),
        ),
      ),
    );
  }
}

class _TabRow extends StatelessWidget {
  final TabController controller;
  const _TabRow({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _cream,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TabBar(
        controller: controller,
        labelColor: _green,
        unselectedLabelColor: _inkLight,
        indicatorColor: _gold,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2.5,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontFamily: 'NotoNaskhArabic', fontSize: 14, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontFamily: 'NotoNaskhArabic', fontSize: 14),
        tabs: const [Tab(text: 'السور'), Tab(text: 'الأجزاء'), Tab(text: 'المفضلة')],
      ),
    );
  }
}

class _SurahTab extends ConsumerWidget {
  final String query;
  const _SurahTab({required this.query});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahListProvider);
    return surahsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: _gold, strokeWidth: 2)),
      error: (e, _) => Center(child: Text('$e', style: const TextStyle(color: _inkMid))),
      data: (surahs) {
        final filtered = query.isEmpty ? surahs : surahs.where((s) =>
          s.nameArabic.contains(query) || s.nameTransliteration.toLowerCase().contains(query.toLowerCase())).toList();
        return ListView.separated(
          padding: const EdgeInsets.only(top: 6, bottom: 100),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => Divider(color: _gold.withOpacity(0.1), height: 1, indent: 70, endIndent: 16),
          itemBuilder: (_, i) => _SurahRow(
            surah: filtered[i],
            onTap: () => context.push('/quran/surah/${filtered[i].number}'),
          ),
        );
      },
    );
  }
}

class _SurahRow extends StatelessWidget {
  final dynamic surah;
  final VoidCallback onTap;
  const _SurahRow({required this.surah, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final isMeccan = surah.revelationType == 'meccan';
    return InkWell(
      onTap: onTap,
      splashColor: _gold.withOpacity(0.08),
      highlightColor: _gold.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _NumberBadge(number: surah.number),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(surah.nameTransliteration, style: const TextStyle(fontSize: 11, color: _inkMid, height: 1.2, letterSpacing: 0.3)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isMeccan ? _gold.withOpacity(0.1) : _green.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: isMeccan ? _gold.withOpacity(0.28) : _green.withOpacity(0.22), width: 0.5),
                      ),
                      child: Text(isMeccan ? 'مكية' : 'مدنية', style: TextStyle(fontFamily: 'NotoNaskhArabic', fontSize: 10, color: isMeccan ? _gold : _green)),
                    ),
                    const SizedBox(width: 6),
                    Text('${ArabicUtils.toArabicNumerals(surah.ayahCount)} آية', style: const TextStyle(fontFamily: 'NotoNaskhArabic', fontSize: 11, color: _inkLight)),
                  ]),
                ],
              ),
            ),
            Text(surah.nameArabic, style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 22, color: _ink, height: 1.5), locale: const Locale('ar')),
          ],
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  final int number;
  const _NumberBadge({required this.number});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40, height: 40,
      decoration: BoxDecoration(
        color: _gold.withOpacity(0.08),
        border: Border.all(color: _gold.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(child: Text(ArabicUtils.toArabicNumerals(number), style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 13, color: _gold, fontWeight: FontWeight.w700))),
    );
  }
}

class _JuzTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.0),
      itemCount: 30,
      itemBuilder: (_, i) {
        final juz = i + 1;
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            splashColor: _gold.withOpacity(0.12),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [_parchment, Color(0xFFEEE8D8)]),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _gold.withOpacity(0.28), width: 1),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(ArabicUtils.toArabicNumerals(juz), style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 32, color: _green, fontWeight: FontWeight.w700, height: 1.2)),
                const SizedBox(height: 2),
                Text('الجزء', style: TextStyle(fontFamily: 'NotoNaskhArabic', fontSize: 11, color: _inkMid.withOpacity(0.8))),
              ]),
            ),
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
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(color: _gold.withOpacity(0.08), shape: BoxShape.circle, border: Border.all(color: _gold.withOpacity(0.25), width: 1)),
          child: Icon(Icons.bookmark_outline_rounded, size: 34, color: _gold.withOpacity(0.55)),
        ),
        const SizedBox(height: 16),
        const Text('لا توجد إشارات مرجعية', style: TextStyle(fontFamily: 'NotoNaskhArabic', color: _inkMid, fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text('اضغط 🔖 على أي آية لحفظها', style: TextStyle(fontSize: 12, color: _inkLight.withOpacity(0.8))),
      ]),
    );
  }
}
