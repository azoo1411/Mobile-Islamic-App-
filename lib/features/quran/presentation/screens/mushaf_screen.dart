import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../../database/app_database.dart';
import '../providers/bookmarks_provider.dart';

// ─── Reading mode ─────────────────────────────────────────────────────────────

enum MushafMode { white, sepia, dark }

extension _MushafModeX on MushafMode {
  Color get background => switch (this) {
        MushafMode.white => const Color(0xFFFAF7F0),
        MushafMode.sepia => const Color(0xFFEEDFBB),
        MushafMode.dark  => const Color(0xFF18181B),
      };

  ColorFilter? get filter => switch (this) {
        MushafMode.white => null,
        MushafMode.sepia => const ColorFilter.matrix([
            0.393, 0.769, 0.189, 0, 0,
            0.349, 0.686, 0.168, 0, 0,
            0.272, 0.534, 0.131, 0, 0,
            0,     0,     0,     1, 0,
          ]),
        MushafMode.dark => const ColorFilter.matrix([
            -1, 0,  0,  0, 255,
            0,  -1, 0,  0, 255,
            0,  0,  -1, 0, 255,
            0,  0,  0,  1, 0,
          ]),
      };

  IconData get icon => switch (this) {
        MushafMode.white => Icons.brightness_high_outlined,
        MushafMode.sepia => Icons.wb_incandescent_outlined,
        MushafMode.dark  => Icons.nightlight_round,
      };

  String get label => switch (this) {
        MushafMode.white => 'فاتح',
        MushafMode.sepia => 'بيج',
        MushafMode.dark  => 'داكن',
      };
}

// ─── Page-info provider ───────────────────────────────────────────────────────

class MushafPageInfo {
  final String surahName;
  final int juzNumber;
  const MushafPageInfo({required this.surahName, required this.juzNumber});
}

final mushafPageInfoProvider =
    FutureProvider.family<MushafPageInfo?, int>((ref, page) async {
  final db = ref.watch(appDatabaseProvider);
  final ayah = await db.quranDao.getFirstAyahOnPage(page);
  if (ayah == null) return null;
  final surah = await db.quranDao.getSurahByNumber(ayah.surahNumber);
  return MushafPageInfo(
    surahName: surah?.nameArabic ?? '',
    juzNumber: ayah.juzNumber,
  );
});

// ─── Screen ───────────────────────────────────────────────────────────────────

class MushafScreen extends ConsumerStatefulWidget {
  final int initialPage;
  const MushafScreen({super.key, this.initialPage = 1});

  @override
  ConsumerState<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends ConsumerState<MushafScreen> {
  late PageController _pageController;
  late int _currentPage;
  int _sliderPage = 1; // tracks slider while dragging
  bool _showOverlay = true;
  MushafMode _mode = MushafMode.white;

  static const _prefMode = 'mushaf_mode';

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(1, 604);
    _sliderPage = _currentPage;
    _pageController = PageController(initialPage: _currentPage - 1);
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    // Mode
    final modeStr = prefs.getString(_prefMode) ?? 'white';
    final mode = MushafMode.values.firstWhere(
      (m) => m.name == modeStr,
      orElse: () => MushafMode.white,
    );

    // Last page (only when opened from default)
    final savedPage = widget.initialPage == 1
        ? (prefs.getInt(AppConstants.prefLastMushafPage) ?? 1)
        : widget.initialPage;

    if (mounted) {
      setState(() {
        _mode = mode;
        if (savedPage > 1) {
          _currentPage = savedPage;
          _sliderPage = savedPage;
        }
      });
      if (savedPage > 1 && widget.initialPage == 1) {
        _pageController.jumpToPage(savedPage - 1);
        _showResumeSnackBar(savedPage);
      }
    }
  }

  void _showResumeSnackBar(int page) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'استُؤنفت القراءة من صفحة ${ArabicUtils.toArabicNumerals(page)}',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontFamily: 'NotoNaskhArabic'),
        ),
        backgroundColor: const Color(0xFF1B4D3E),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'البداية',
          textColor: const Color(0xFFD4AF37),
          onPressed: () {
            _pageController.jumpToPage(0);
            setState(() {
              _currentPage = 1;
              _sliderPage = 1;
            });
          },
        ),
      ),
    );
  }

  Future<void> _savePage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(AppConstants.prefLastMushafPage, page);
  }

  Future<void> _cycleMode() async {
    final next =
        MushafMode.values[(_mode.index + 1) % MushafMode.values.length];
    setState(() => _mode = next);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_prefMode, next.name);
  }

  Future<void> _jumpToPage() async {
    final controller = TextEditingController();
    final result = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('انتقل إلى صفحة',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'NotoNaskhArabic')),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(hintText: '1 – 604'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              final p = int.tryParse(controller.text);
              if (p != null && p >= 1 && p <= 604) Navigator.pop(context, p);
            },
            child: const Text('انتقال'),
          ),
        ],
      ),
    );
    if (result != null && mounted) {
      _pageController.animateToPage(
        result - 1,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = ref.watch(mushafPageInfoProvider(_currentPage));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _showOverlay
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  _mode == MushafMode.dark ? Brightness.light : Brightness.dark,
            ),
      child: Scaffold(
        backgroundColor: _mode.background,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _showOverlay = !_showOverlay),
          child: Stack(
            children: [
              // ── Pages ──────────────────────────────────────────
              PageView.builder(
                controller: _pageController,
                reverse: true,
                itemCount: 604,
                onPageChanged: (i) {
                  setState(() {
                    _currentPage = i + 1;
                    _sliderPage = i + 1;
                  });
                  _savePage(i + 1);
                },
                itemBuilder: (_, i) =>
                    _MushafPageImage(pageNumber: i + 1, mode: _mode),
              ),

              // ── Top overlay ────────────────────────────────────
              AnimatedOpacity(
                opacity: _showOverlay ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !_showOverlay,
                  child: _TopOverlay(
                    info: info,
                    currentPage: _currentPage,
                    mode: _mode,
                    onBack: () => Navigator.pop(context),
                    onJump: _jumpToPage,
                    onBookmark: () => toggleMushafBookmark(ref, _currentPage),
                    onCycleMode: _cycleMode,
                  ),
                ),
              ),

              // ── Bottom overlay ─────────────────────────────────
              AnimatedOpacity(
                opacity: _showOverlay ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !_showOverlay,
                  child: _BottomOverlay(
                    currentPage: _currentPage,
                    sliderPage: _sliderPage,
                    mode: _mode,
                    onSliderChanged: (v) =>
                        setState(() => _sliderPage = v.round()),
                    onSliderEnd: (v) {
                      final p = v.round();
                      _pageController.jumpToPage(p - 1);
                      _savePage(p);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Top overlay ──────────────────────────────────────────────────────────────

class _TopOverlay extends ConsumerWidget {
  final AsyncValue<MushafPageInfo?> info;
  final int currentPage;
  final MushafMode mode;
  final VoidCallback onBack;
  final VoidCallback onJump;
  final VoidCallback onBookmark;
  final VoidCallback onCycleMode;

  const _TopOverlay({
    required this.info,
    required this.currentPage,
    required this.mode,
    required this.onBack,
    required this.onJump,
    required this.onBookmark,
    required this.onCycleMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(isPageBookmarkedProvider(currentPage));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.6), Colors.transparent],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 20),
                onPressed: onBack,
              ),
              Expanded(
                child: info.when(
                  data: (d) => d == null
                      ? const SizedBox.shrink()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              d.surahName,
                              style: const TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'الجزء ${ArabicUtils.toArabicNumerals(d.juzNumber)}',
                              style: const TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
              // Mode toggle
              IconButton(
                icon: Icon(mode.icon, color: Colors.white, size: 20),
                tooltip: mode.label,
                onPressed: onCycleMode,
              ),
              // Bookmark
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? const Color(0xFFD4AF37) : Colors.white,
                  size: 22,
                ),
                onPressed: onBookmark,
              ),
              // Page jump
              IconButton(
                icon: const Icon(Icons.find_in_page_outlined,
                    color: Colors.white, size: 22),
                onPressed: onJump,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Bottom overlay (with page slider) ───────────────────────────────────────

class _BottomOverlay extends StatelessWidget {
  final int currentPage;
  final int sliderPage;
  final MushafMode mode;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<double> onSliderEnd;

  const _BottomOverlay({
    required this.currentPage,
    required this.sliderPage,
    required this.mode,
    required this.onSliderChanged,
    required this.onSliderEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 16, top: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.55), Colors.transparent],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Page number while dragging
              Text(
                ArabicUtils.toArabicNumerals(sliderPage),
                style: const TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              // Slider
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFD4AF37),
                  inactiveTrackColor: Colors.white24,
                  thumbColor: const Color(0xFFD4AF37),
                  overlayColor: const Color(0x44D4AF37),
                  trackHeight: 2,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 14),
                ),
                child: Slider(
                  value: sliderPage.toDouble(),
                  min: 1,
                  max: 604,
                  onChanged: onSliderChanged,
                  onChangeEnd: onSliderEnd,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Single page image ────────────────────────────────────────────────────────

class _MushafPageImage extends StatelessWidget {
  final int pageNumber;
  final MushafMode mode;
  const _MushafPageImage({required this.pageNumber, required this.mode});

  String get _url {
    final p = pageNumber.toString().padLeft(3, '0');
    return '${AppConstants.mushafImageBaseUrl}/page-$p.jpg';
  }

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: _url,
      fit: BoxFit.contain,
      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: mode == MushafMode.dark
            ? const Color(0xFF2A2A2F)
            : const Color(0xFFEDE8DC),
        highlightColor: mode == MushafMode.dark
            ? const Color(0xFF3A3A40)
            : const Color(0xFFF8F5EE),
        child: Container(
          decoration: BoxDecoration(
            color: mode.background,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined,
                size: 64,
                color: mode == MushafMode.dark
                    ? Colors.white38
                    : const Color(0xFFD4AF37)),
            const SizedBox(height: 12),
            Text(
              'تعذّر تحميل الصفحة',
              style: TextStyle(
                fontFamily: 'NotoNaskhArabic',
                color: mode == MushafMode.dark
                    ? Colors.white38
                    : const Color(0xFF888888),
              ),
            ),
          ],
        ),
      ),
    );

    if (mode.filter != null) {
      image = ColorFiltered(colorFilter: mode.filter!, child: image);
    }

    return Padding(padding: const EdgeInsets.all(4), child: image);
  }
}
