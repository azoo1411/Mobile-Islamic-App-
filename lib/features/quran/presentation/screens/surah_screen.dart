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
import '../providers/tafsir_provider.dart';
import '../widgets/tafsir_sheet.dart';

// ─── Design tokens ────────────────────────────────────────────────────────────

const _navy     = Color(0xFF080D1A);
const _navyCard = Color(0xFF0F1629);
const _navyEle  = Color(0xFF17203A);
const _gold     = Color(0xFFD4AF37);
const _goldDim  = Color(0x33D4AF37);
const _white     = Colors.white;
const _white70   = Color(0xB3FFFFFF);
const _white40   = Color(0x66FFFFFF);
const _white15   = Color(0x26FFFFFF);

// ─── Screen ───────────────────────────────────────────────────────────────────

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
  bool _headerVisible = true;
  int? _selectedAyah; // ayah number with open inline actions
  bool _showTafsir = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final show = _scrollController.offset < 80;
    if (show != _headerVisible) setState(() => _headerVisible = show);
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

  @override
  Widget build(BuildContext context) {
    final surahAsync = ref.watch(surahDetailsProvider(widget.surahNumber));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _navy,
        body: surahAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: _gold, strokeWidth: 2)),
          error: (e, _) => Center(
              child: Text('$e',
                  style: const TextStyle(color: _white70))),
          data: (data) => Stack(
            children: [
              // ── Main scroll area ───────────────────────────
              CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Collapsible header
                  SliverToBoxAdapter(
                    child: _SurahHeader(
                      surah: data.surah,
                      visible: _headerVisible,
                    ),
                  ),

                  // Basmala
                  if (data.surah.number != 1 && data.surah.number != 9)
                    const SliverToBoxAdapter(child: _Basmala()),

                  // Ayah list
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) {
                        final ayah = data.ayahs[i];
                        return _AyahTile(
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

              // ── Floating header bar (fades in on scroll) ──
              _FloatingBar(
                surah: data.surah,
                visible: !_headerVisible,
                fontSize: _fontSize,
                onBack: () => Navigator.pop(context),
                onFontIncrease: () =>
                    setState(() => _fontSize = (_fontSize + 1).clamp(18, 34)),
                onFontDecrease: () =>
                    setState(() => _fontSize = (_fontSize - 1).clamp(18, 34)),
              ),

              // ── Mini audio player ──────────────────────────
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

// ─── Surah header ─────────────────────────────────────────────────────────────

class _SurahHeader extends StatelessWidget {
  final Surah surah;
  final bool visible;
  const _SurahHeader({required this.surah, required this.visible});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 48, 16, 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              _gold.withOpacity(0.12),
              _navyCard,
              _navyCard,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          border: Border.all(color: _gold.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            // Back button row
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _white15,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        color: _white70, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Surah name
            Text(
              surah.nameArabic,
              style: const TextStyle(
                fontFamily: 'AmiriQuran',
                fontSize: 36,
                color: _white,
                height: 1.4,
              ),
              locale: const Locale('ar'),
            ),
            const SizedBox(height: 6),
            Text(
              surah.nameTransliteration,
              style: const TextStyle(
                fontSize: 13,
                color: _white40,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            // Pills row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Pill(
                  label: surah.revelationType == 'meccan' ? 'مكية' : 'مدنية',
                  color: _gold,
                ),
                const SizedBox(width: 8),
                _Pill(
                  label:
                      '${ArabicUtils.toArabicNumerals(surah.ayahCount)} آية',
                  color: _white40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  const _Pill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withOpacity(0.12),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'NotoNaskhArabic',
          fontSize: 11,
          color: color == _white40 ? _white70 : color,
        ),
      ),
    );
  }
}

// ─── Basmala ──────────────────────────────────────────────────────────────────

class _Basmala extends StatelessWidget {
  const _Basmala();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Text(
        'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        locale: const Locale('ar'),
        style: const TextStyle(
          fontFamily: 'AmiriQuran',
          fontSize: 26,
          color: _gold,
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

// ─── Ayah tile ────────────────────────────────────────────────────────────────

class _AyahTile extends ConsumerWidget {
  final Ayah ayah;
  final double fontSize;
  final bool isSelected;
  final VoidCallback onTap;

  const _AyahTile({
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isPlaying
              ? _gold.withOpacity(0.10)
              : isSelected
                  ? _navyEle
                  : Colors.transparent,
          border: isPlaying
              ? Border.all(color: _gold.withOpacity(0.35), width: 1)
              : isSelected
                  ? Border.all(color: _white15, width: 1)
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ayah number badge
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 6),
                    child: _AyahBadge(
                        number: ayah.ayahNumber, isPlaying: isPlaying),
                  ),
                  const SizedBox(width: 8),
                  // Ayah text
                  Expanded(
                    child: Text(
                      ayah.textUthmani,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.justify,
                      locale: const Locale('ar'),
                      style: TextStyle(
                        fontFamily: 'AmiriQuran',
                        fontSize: fontSize,
                        height: 2.1,
                        color: isPlaying ? _gold : _white,
                        fontFeatures: const [
                          FontFeature.enable('calt'),
                          FontFeature.enable('liga'),
                          FontFeature.enable('clig'),
                        ],
                      ),
                    ),
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
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isPlaying ? _gold : _navyEle,
        border: Border.all(
          color: isPlaying ? _gold : _white15,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          ArabicUtils.toArabicNumerals(number),
          style: TextStyle(
            fontFamily: 'AmiriQuran',
            fontSize: 11,
            color: isPlaying ? _navy : _white70,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ─── Inline ayah actions ──────────────────────────────────────────────────────

class _AyahActions extends ConsumerWidget {
  final Ayah ayah;
  const _AyahActions({required this.ayah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioServiceProvider);
    final isThisPlaying = audioState.isPlaying &&
        audioState.surahNumber == ayah.surahNumber &&
        audioState.ayahNumber == ayah.ayahNumber;

    // Bookmark check
    final bookmarks = ref.watch(mushafBookmarksProvider).valueOrNull ?? [];
    final isBookmarked =
        bookmarks.any((b) => b.referenceId == 'a_${ayah.surahNumber}_${ayah.ayahNumber}');

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Play / Pause
          _ActionChip(
            icon: isThisPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            label: isThisPlaying ? 'إيقاف' : 'تشغيل',
            color: _gold,
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
            color: Colors.blue.shade300,
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
            color: isBookmarked ? _gold : _white40,
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
  const _ActionChip(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color.withOpacity(0.12),
          border: Border.all(color: color.withOpacity(0.35), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 15),
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

// ─── Floating bar (appears on scroll) ────────────────────────────────────────

class _FloatingBar extends StatelessWidget {
  final Surah surah;
  final bool visible;
  final double fontSize;
  final VoidCallback onBack;
  final VoidCallback onFontIncrease;
  final VoidCallback onFontDecrease;

  const _FloatingBar({
    required this.surah,
    required this.visible,
    required this.fontSize,
    required this.onBack,
    required this.onFontIncrease,
    required this.onFontDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 220),
      child: IgnorePointer(
        ignoring: !visible,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _navyCard.withOpacity(0.97),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _white15, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onBack,
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: _white70, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    surah.nameArabic,
                    style: const TextStyle(
                      fontFamily: 'AmiriQuran',
                      fontSize: 18,
                      color: _white,
                    ),
                    locale: const Locale('ar'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Font controls
                GestureDetector(
                  onTap: onFontDecrease,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child:
                        Icon(Icons.text_decrease, color: _white70, size: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '${fontSize.round()}',
                    style:
                        const TextStyle(color: _gold, fontSize: 12),
                  ),
                ),
                GestureDetector(
                  onTap: onFontIncrease,
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child:
                        Icon(Icons.text_increase, color: _white70, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Mini audio player ────────────────────────────────────────────────────────

class _MiniPlayer extends ConsumerWidget {
  const _MiniPlayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioServiceProvider);
    if (!state.isVisible) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: _navyCard,
        border: Border(top: BorderSide(color: _gold.withOpacity(0.25), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -4),
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
                width: 34,
                height: 34,
                child: CircularProgressIndicator(
                  value: state.isLoading ? null : state.progress,
                  backgroundColor: _white15,
                  color: _gold,
                  strokeWidth: 2.5,
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
                        color: _white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _reciterName(state.reciterId),
                      style: const TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          color: _white40,
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
              _PlayerBtn(
                icon: Icons.skip_next,
                onTap: () => ref.read(audioServiceProvider.notifier).next(),
              ),
              _PlayerBtn(
                icon: state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 30,
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
                color: _white40,
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
    this.color = _white70,
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
