import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../../database/app_database.dart';
import '../providers/audio_provider.dart';
import '../providers/bookmarks_provider.dart';
import '../providers/quran_provider.dart';
import '../widgets/tafsir_sheet.dart';

// ─── Design tokens ─────────────────────────────────────────────────────────────
const _cream    = Color(0xFFFAF8F0);
const _parchment = Color(0xFFF0EAD6);
const _ink      = Color(0xFF1A1208);
const _inkMid   = Color(0xFF5C4A2A);
const _inkLight = Color(0xFFAA9070);
const _gold     = Color(0xFFC8A820);
const _green    = Color(0xFF1B4D3E);

// ─── Screen ────────────────────────────────────────────────────────────────────
class SurahScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final int startAyah;

  const SurahScreen({
    super.key,
    required this.surahNumber,
    this.startAyah = 1,
  });

  @override
  ConsumerState<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends ConsumerState<SurahScreen> {
  final _scrollController = ScrollController();
  double _fontSize = 22.0;
  bool _showStickyBar = false;
  int? _selectedAyah;
  final Map<int, GlobalKey> _ayahKeys = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final show = _scrollController.offset > 160;
    if (show != _showStickyBar) setState(() => _showStickyBar = show);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleAyah(int number) {
    setState(() => _selectedAyah = _selectedAyah == number ? null : number);
  }

  void _scrollToAyah(int ayahNumber) {
    final key = _ayahKeys[ayahNumber];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOut,
        alignment: 0.25,
      );
    }
  }

  GlobalKey _keyFor(int ayahNumber) =>
      _ayahKeys.putIfAbsent(ayahNumber, () => GlobalKey());

  @override
  Widget build(BuildContext context) {
    final surahAsync = ref.watch(surahDetailsProvider(widget.surahNumber));

    // Auto-scroll when playing ayah changes
    ref.listen<({int surah, int ayah})?>(currentlyPlayingAyahProvider,
        (prev, next) {
      if (next != null &&
          next.surah == widget.surahNumber &&
          next.ayah != prev?.ayah) {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => _scrollToAyah(next.ayah));
      }
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _cream,
        body: surahAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: _gold, strokeWidth: 2)),
          error: (e, _) =>
              Center(child: Text('$e', style: const TextStyle(color: _inkMid))),
          data: (data) => Stack(
            children: [
              // ── Main scroll area ──────────────────────────────
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Surah header (collapses on scroll)
                  SliverToBoxAdapter(
                    child: _SurahHeader(
                      surah: data.surah,
                      onBack: () => Navigator.pop(context),
                    ),
                  ),
                  // Basmala (except Al-Fatiha and At-Tawba)
                  if (data.surah.number != 1 && data.surah.number != 9)
                    const SliverToBoxAdapter(child: _Basmala()),
                  // Ayah list
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final ayah = data.ayahs[i];
                        return _AyahTile(
                          key: _keyFor(ayah.ayahNumber),
                          ayah: ayah,
                          fontSize: _fontSize,
                          isSelected: _selectedAyah == ayah.ayahNumber,
                          onTap: () => _toggleAyah(ayah.ayahNumber),
                        );
                      },
                      childCount: data.ayahs.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ),

              // ── Reading progress bar (top) ─────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _scrollController,
                  builder: (_, __) {
                    final progress = _scrollController.hasClients &&
                            _scrollController.position.maxScrollExtent > 0
                        ? (_scrollController.offset /
                                _scrollController.position.maxScrollExtent)
                            .clamp(0.0, 1.0)
                        : 0.0;
                    return LinearProgressIndicator(
                      value: progress,
                      minHeight: 2,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(_gold),
                    );
                  },
                ),
              ),

              // ── Sticky bar (appears after scrolling past header) ─
              AnimatedSlide(
                offset: _showStickyBar ? Offset.zero : const Offset(0, -1),
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOut,
                child: AnimatedOpacity(
                  opacity: _showStickyBar ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !_showStickyBar,
                    child: _StickyBar(
                      surah: data.surah,
                      fontSize: _fontSize,
                      onBack: () => Navigator.pop(context),
                      onFontIncrease: () => setState(
                          () => _fontSize = (_fontSize + 1).clamp(18, 34)),
                      onFontDecrease: () => setState(
                          () => _fontSize = (_fontSize - 1).clamp(18, 34)),
                    ),
                  ),
                ),
              ),

              // ── Mini audio player (bottom) ─────────────────────
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _MiniPlayer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Surah header ──────────────────────────────────────────────────────────────
class _SurahHeader extends StatelessWidget {
  final Surah surah;
  final VoidCallback onBack;
  const _SurahHeader({required this.surah, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _green,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Nav row
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 16, 0),
              child: Row(
                children: [
                  InkWell(
                    onTap: onBack,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: _gold.withAlpha(200), size: 18),
                    ),
                  ),
                  const Spacer(),
                  // Juz indicator
                  Text(
                    '${ArabicUtils.toArabicNumerals(surah.number)} :',
                    style: TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 12,
                      color: _gold.withAlpha(160),
                    ),
                  ),
                ],
              ),
            ),
            // Surah name
            Text(
              surah.nameArabic,
              style: const TextStyle(
                fontFamily: 'AmiriQuran',
                fontSize: 32,
                color: _gold,
                height: 1.5,
              ),
              locale: const Locale('ar'),
            ),
            const SizedBox(height: 2),
            Text(
              surah.nameTransliteration,
              style: TextStyle(
                fontSize: 12,
                color: _gold.withAlpha(150),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            // Pills
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _HeaderPill(
                  label: surah.revelationType == 'meccan' ? 'مكية' : 'مدنية',
                ),
                const SizedBox(width: 8),
                _HeaderPill(
                  label:
                      '${ArabicUtils.toArabicNumerals(surah.ayahCount)} آية',
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Decorative gold divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                      child: Container(height: 1, color: _gold.withAlpha(80))),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _gold.withAlpha(130),
                    ),
                  ),
                  Expanded(
                      child: Container(height: 1, color: _gold.withAlpha(80))),
                ],
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  final String label;
  const _HeaderPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _gold.withAlpha(30),
        border: Border.all(color: _gold.withAlpha(80), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'NotoNaskhArabic',
          fontSize: 11,
          color: _gold.withAlpha(220),
        ),
      ),
    );
  }
}

// ─── Basmala ───────────────────────────────────────────────────────────────────
class _Basmala extends StatelessWidget {
  const _Basmala();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Text(
        'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        locale: const Locale('ar'),
        style: const TextStyle(
          fontFamily: 'AmiriQuran',
          fontSize: 26,
          color: _green,
          height: 2.0,
          fontFeatures: [
            FontFeature.enable('calt'),
            FontFeature.enable('liga'),
          ],
        ),
      ),
    );
  }
}

// ─── Ayah tile ─────────────────────────────────────────────────────────────────
class _AyahTile extends ConsumerWidget {
  final Ayah ayah;
  final double fontSize;
  final bool isSelected;
  final VoidCallback onTap;

  const _AyahTile({
    super.key,
    required this.ayah,
    required this.fontSize,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playing = ref.watch(currentlyPlayingAyahProvider);
    final isPlaying = playing?.surah == ayah.surahNumber &&
        playing?.ayah == ayah.ayahNumber;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => showTafsirSheet(
        context,
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
        ayahText: ayah.textUthmani,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isPlaying
              ? _gold.withAlpha(22)
              : isSelected
                  ? _parchment
                  : Colors.transparent,
          border: isPlaying
              ? Border(left: BorderSide(color: _gold, width: 3))
              : isSelected
                  ? Border.all(color: _gold.withAlpha(60), width: 0.5)
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  // Ayah text (RTL, takes most space)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        ayah.textUthmani,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.justify,
                        locale: const Locale('ar'),
                        style: TextStyle(
                          fontFamily: 'AmiriQuran',
                          fontSize: fontSize,
                          height: 2.2,
                          color: isPlaying ? _green : _ink,
                          fontFeatures: const [
                            FontFeature.enable('calt'),
                            FontFeature.enable('liga'),
                            FontFeature.enable('clig'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Ayah number badge
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 6),
                    child: _AyahBadge(
                        number: ayah.ayahNumber, isPlaying: isPlaying),
                  ),
                ],
              ),
            ),
            // Inline action row (visible when selected)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 180),
              firstChild: const SizedBox.shrink(),
              secondChild: _AyahActions(ayah: ayah),
              crossFadeState: isSelected
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }
}

class _AyahBadge extends StatelessWidget {
  final int number;
  final bool isPlaying;
  const _AyahBadge({required this.number, required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isPlaying ? _gold.withAlpha(40) : _gold.withAlpha(18),
        border: Border.all(
          color: isPlaying ? _gold : _gold.withAlpha(100),
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          ArabicUtils.toArabicNumerals(number),
          style: TextStyle(
            fontFamily: 'AmiriQuran',
            fontSize: 11,
            color: isPlaying ? _green : _gold,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─── Inline ayah actions ───────────────────────────────────────────────────────
class _AyahActions extends ConsumerWidget {
  final Ayah ayah;
  const _AyahActions({required this.ayah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioServiceProvider);
    final isThisPlaying = audioState.isPlaying &&
        audioState.surahNumber == ayah.surahNumber &&
        audioState.ayahNumber == ayah.ayahNumber;

    final bookmarks = ref.watch(mushafBookmarksProvider).valueOrNull ?? [];
    final isBookmarked = bookmarks
        .any((b) => b.referenceId == 'a_${ayah.surahNumber}_${ayah.ayahNumber}');

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Play / Pause
          _ActionChip(
            icon: isThisPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            label: isThisPlaying ? 'إيقاف' : 'تشغيل',
            color: _green,
            onTap: () {
              if (isThisPlaying) {
                ref.read(audioServiceProvider.notifier).pause();
              } else {
                ref.read(audioServiceProvider.notifier).playAyah(
                      surahNumber: ayah.surahNumber,
                      ayahNumber: ayah.ayahNumber,
                    );
              }
            },
          ),
          const SizedBox(width: 8),
          // Tafsir
          _ActionChip(
            icon: Icons.menu_book_outlined,
            label: 'تفسير',
            color: _inkMid,
            onTap: () => showTafsirSheet(
              context,
              surahNumber: ayah.surahNumber,
              ayahNumber: ayah.ayahNumber,
              ayahText: ayah.textUthmani,
            ),
          ),
          const SizedBox(width: 8),
          // Bookmark
          _ActionChip(
            icon: isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded,
            label: 'حفظ',
            color: isBookmarked ? _gold : _inkLight,
            onTap: () async {
              final dao = ref.read(appDatabaseProvider).bookmarksDao;
              final key = 'a_${ayah.surahNumber}_${ayah.ayahNumber}';
              if (isBookmarked) {
                await dao.removeBookmark('ayah', key);
              } else {
                await dao.addBookmark(
                  BookmarksCompanion(
                    bookmarkType: const Value('ayah'),
                    referenceId: Value(key),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color.withAlpha(20),
          border: Border.all(color: color.withAlpha(80), width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'NotoNaskhArabic',
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Sticky top bar (appears after scrolling) ──────────────────────────────────
class _StickyBar extends StatelessWidget {
  final Surah surah;
  final double fontSize;
  final VoidCallback onBack;
  final VoidCallback onFontIncrease;
  final VoidCallback onFontDecrease;

  const _StickyBar({
    required this.surah,
    required this.fontSize,
    required this.onBack,
    required this.onFontIncrease,
    required this.onFontDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _green,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 2, color: _gold),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Row(
                children: [
                  InkWell(
                    onTap: onBack,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: _gold.withAlpha(200), size: 18),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      surah.nameArabic,
                      textAlign: TextAlign.center,
                      locale: const Locale('ar'),
                      style: const TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontSize: 20,
                        color: _gold,
                        height: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Font size controls
                  InkWell(
                    onTap: onFontDecrease,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.text_decrease,
                          color: Colors.white70, size: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      '${fontSize.round()}',
                      style: const TextStyle(
                          color: _gold, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  InkWell(
                    onTap: onFontIncrease,
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.text_increase,
                          color: Colors.white70, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: _gold.withAlpha(60)),
          ],
        ),
      ),
    );
  }
}

// ─── Mini audio player ─────────────────────────────────────────────────────────
class _MiniPlayer extends ConsumerWidget {
  const _MiniPlayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioServiceProvider);
    if (!state.isVisible) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: _green,
        border: Border(top: BorderSide(color: _gold.withAlpha(80), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              // Progress ring
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  value: state.isLoading ? null : state.progress,
                  backgroundColor: Colors.white24,
                  color: _gold,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'آية ${ArabicUtils.toArabicNumerals(state.ayahNumber)}',
                      style: const TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _reciterName(state.reciterId),
                      style: TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        color: _gold.withAlpha(200),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              _PlayerBtn(
                icon: Icons.skip_next,
                onTap: () => ref.read(audioServiceProvider.notifier).next(),
              ),
              _PlayerBtn(
                icon: state.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                size: 28,
                color: _gold,
                onTap: () {
                  if (state.isPlaying) {
                    ref.read(audioServiceProvider.notifier).pause();
                  } else {
                    ref.read(audioServiceProvider.notifier).resume();
                  }
                },
              ),
              _PlayerBtn(
                icon: Icons.skip_previous,
                onTap: () => ref.read(audioServiceProvider.notifier).previous(),
              ),
              _PlayerBtn(
                icon: Icons.close,
                size: 18,
                color: Colors.white54,
                onTap: () => ref.read(audioServiceProvider.notifier).hide(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _reciterName(String id) {
    return AppConstants.reciters
        .firstWhere((r) => r['id'] == id,
            orElse: () => {'name': 'قارئ'})['name']!;
  }
}

class _PlayerBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback onTap;
  const _PlayerBtn({
    required this.icon,
    required this.onTap,
    this.size = 22,
    this.color = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
