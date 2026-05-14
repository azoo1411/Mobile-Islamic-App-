import 'dart:math' show sin, pi;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../../database/app_database.dart';
import '../providers/bookmarks_provider.dart';

// ─── Constants ─────────────────────────────────────────────────────────────────
const _prefMode  = 'mushaf_mode';
const _prefZoom  = 'mushaf_zoom';

// ─── Reading mode ──────────────────────────────────────────────────────────────
enum MushafMode { light, sepia, dark }

extension _ModeX on MushafMode {
  // Page background (cream in light, warm sepia, deep charcoal in dark)
  Color get pageBg => switch (this) {
        MushafMode.light => const Color(0xFFFBF9F2),
        MushafMode.sepia => const Color(0xFFEDD9A3),
        MushafMode.dark  => const Color(0xFF12151C),
      };

  // Screen surround (slightly darker than page)
  Color get screenBg => switch (this) {
        MushafMode.light => const Color(0xFFEDE8DA),
        MushafMode.sepia => const Color(0xFFD9C07A),
        MushafMode.dark  => const Color(0xFF0A0D12),
      };

  // Overlay bar background
  Color get barBg => switch (this) {
        MushafMode.light => const Color(0xFFF4EFDF),
        MushafMode.sepia => const Color(0xFFE5CE8F),
        MushafMode.dark  => const Color(0xFF1A1D26),
      };

  Color get text => switch (this) {
        MushafMode.light => const Color(0xFF1C1208),
        MushafMode.sepia => const Color(0xFF2D1B08),
        MushafMode.dark  => const Color(0xFFE8DCC8),
      };

  Color get subtext => switch (this) {
        MushafMode.light => const Color(0xFF6B5A3E),
        MushafMode.sepia => const Color(0xFF7A5C2A),
        MushafMode.dark  => const Color(0xFF9E8866),
      };

  Color get gold => switch (this) {
        MushafMode.light => const Color(0xFFC8A820),
        MushafMode.sepia => const Color(0xFFB08820),
        MushafMode.dark  => const Color(0xFFD4AF37),
      };

  Color get divider => switch (this) {
        MushafMode.light => const Color(0xFFD4C090),
        MushafMode.sepia => const Color(0xFFC0A050),
        MushafMode.dark  => const Color(0xFF2E3040),
      };

  Color get shadowColor => switch (this) {
        MushafMode.light => const Color(0x30000000),
        MushafMode.sepia => const Color(0x28000000),
        MushafMode.dark  => const Color(0x70000000),
      };

  // Page image color filter
  ColorFilter? get filter => switch (this) {
        MushafMode.light => null,
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
        MushafMode.light => Icons.wb_sunny_outlined,
        MushafMode.sepia => Icons.wb_incandescent_outlined,
        MushafMode.dark  => Icons.nightlight_round,
      };

  String get label => switch (this) {
        MushafMode.light => 'نهار',
        MushafMode.sepia => 'بيج',
        MushafMode.dark  => 'ليل',
      };
}

// ─── Page-info provider ────────────────────────────────────────────────────────
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

// ─── Islamic frame painter ────────────────────────────────────────────────────
class _IslamicFramePainter extends CustomPainter {
  final Color color;
  _IslamicFramePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    const m = 5.0;  // outer margin
    const m2 = 9.0; // inner margin
    const arm = 20.0; // corner arm length

    // Outer border rectangle
    canvas.drawRect(Rect.fromLTRB(m, m, size.width - m, size.height - m), stroke);

    // Inner border rectangle
    stroke.strokeWidth = 0.4;
    canvas.drawRect(Rect.fromLTRB(m2, m2, size.width - m2, size.height - m2), stroke);
    stroke.strokeWidth = 0.7;

    // Four corner L-brackets (outer)
    void drawCorner(double cx, double cy, double sx, double sy) {
      canvas.drawLine(Offset(cx, cy), Offset(cx + sx * arm, cy), stroke);
      canvas.drawLine(Offset(cx, cy), Offset(cx, cy + sy * arm), stroke);
      // Diamond dot at corner
      final diamond = Path()
        ..moveTo(cx, cy - 3.5)
        ..lineTo(cx + 2.5, cy)
        ..lineTo(cx, cy + 3.5)
        ..lineTo(cx - 2.5, cy)
        ..close();
      canvas.drawPath(diamond, fill);
    }

    drawCorner(m, m, 1, 1);
    drawCorner(size.width - m, m, -1, 1);
    drawCorner(m, size.height - m, 1, -1);
    drawCorner(size.width - m, size.height - m, -1, -1);

    // Mid-side diamonds
    void midDiamond(double cx, double cy) {
      final d = Path()
        ..moveTo(cx, cy - 4)
        ..lineTo(cx + 3, cy)
        ..lineTo(cx, cy + 4)
        ..lineTo(cx - 3, cy)
        ..close();
      canvas.drawPath(d, fill);
    }

    final cx = size.width / 2;
    final cy = size.height / 2;
    midDiamond(cx, m);
    midDiamond(cx, size.height - m);
    midDiamond(m, cy);
    midDiamond(size.width - m, cy);
  }

  @override
  bool shouldRepaint(_IslamicFramePainter old) => old.color != color;
}

// ─── Screen ────────────────────────────────────────────────────────────────────
class MushafScreen extends ConsumerStatefulWidget {
  final int initialPage;
  const MushafScreen({super.key, this.initialPage = 1});

  @override
  ConsumerState<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends ConsumerState<MushafScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageCtrl;
  late int _currentPage;
  int  _sliderPage  = 1;
  bool _showOverlay = true;
  MushafMode _mode  = MushafMode.light;
  double _zoom      = 1.0;      // 1.0 – 1.6
  double _turnFraction = 0.0;   // 0..0.5, for turning shadow

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(1, 604);
    _sliderPage  = _currentPage;
    _pageCtrl    = PageController(initialPage: _currentPage - 1);
    _pageCtrl.addListener(_onPageScroll);
    _loadPrefs();
  }

  void _onPageScroll() {
    if (!_pageCtrl.hasClients) return;
    final page = _pageCtrl.page ?? _currentPage.toDouble();
    final frac = page - page.floor();
    final half = frac > 0.5 ? 1.0 - frac : frac; // 0..0.5
    if ((half - _turnFraction).abs() > 0.005) {
      setState(() => _turnFraction = half);
    }
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(_prefMode) ?? 'light';
    final mode = MushafMode.values.firstWhere(
      (m) => m.name == modeStr, orElse: () => MushafMode.light,
    );
    final zoom = prefs.getDouble(_prefZoom) ?? 1.0;
    final savedPage = widget.initialPage == 1
        ? (prefs.getInt(AppConstants.prefLastMushafPage) ?? 1)
        : widget.initialPage;

    if (!mounted) return;
    setState(() {
      _mode = mode;
      _zoom = zoom.clamp(0.85, 1.6);
      if (savedPage > 1) {
        _currentPage = savedPage;
        _sliderPage  = savedPage;
      }
    });
    if (savedPage > 1 && widget.initialPage == 1) {
      _pageCtrl.jumpToPage(savedPage - 1);
      _showResumeSnack(savedPage);
    }
  }

  void _showResumeSnack(int page) {
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
            _pageCtrl.jumpToPage(0);
            setState(() { _currentPage = 1; _sliderPage = 1; });
          },
        ),
      ),
    );
  }

  Future<void> _savePage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefLastMushafPage, page);
  }

  Future<void> _cycleMode() async {
    final next = MushafMode.values[(_mode.index + 1) % MushafMode.values.length];
    setState(() => _mode = next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefMode, next.name);
  }

  Future<void> _adjustZoom(double delta) async {
    final next = (_zoom + delta).clamp(0.85, 1.6);
    if (next == _zoom) return;
    setState(() => _zoom = next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_prefZoom, next);
  }

  Future<void> _jumpToPage() async {
    final ctrl = TextEditingController();
    final result = await showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _mode.barBg,
        title: Text('انتقل إلى صفحة',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'NotoNaskhArabic', color: _mode.text)),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          autofocus: true,
          style: TextStyle(color: _mode.text, fontSize: 18),
          decoration: InputDecoration(
            hintText: '١ – ٦٠٤',
            hintStyle: TextStyle(color: _mode.subtext),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _mode.gold)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _mode.gold, width: 2)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء',
                style: TextStyle(
                    fontFamily: 'NotoNaskhArabic', color: _mode.subtext)),
          ),
          TextButton(
            onPressed: () {
              final p = int.tryParse(ctrl.text);
              if (p != null && p >= 1 && p <= 604) Navigator.pop(context, p);
            },
            child: Text('انتقال',
                style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    color: _mode.gold,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (result != null && mounted) {
      _pageCtrl.animateToPage(result - 1,
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    }
  }

  void _showReciterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _mode.barBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ReciterSheet(mode: _mode),
    );
  }

  @override
  void dispose() {
    _pageCtrl.removeListener(_onPageScroll);
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final info = ref.watch(mushafPageInfoProvider(_currentPage));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _mode == MushafMode.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        color: _mode.screenBg,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _showOverlay = !_showOverlay),
            child: Stack(
              children: [
                // ── Main page reader ──────────────────────────────
                PageView.builder(
                  controller: _pageCtrl,
                  reverse: true, // RTL: swipe right = next page
                  itemCount: 604,
                  onPageChanged: (i) {
                    setState(() {
                      _currentPage = i + 1;
                      _sliderPage  = i + 1;
                    });
                    _savePage(i + 1);
                  },
                  itemBuilder: (_, i) => _MushafPage(
                    pageNumber: i + 1,
                    mode: _mode,
                    zoom: _zoom,
                    turnFraction: _turnFraction,
                  ),
                ),

                // ── Top bar (slides in from top) ──────────────────
                AnimatedSlide(
                  offset: _showOverlay ? Offset.zero : const Offset(0, -1),
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    opacity: _showOverlay ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: IgnorePointer(
                      ignoring: !_showOverlay,
                      child: _TopBar(
                        info: info,
                        currentPage: _currentPage,
                        mode: _mode,
                        onBack: () => Navigator.pop(context),
                        onJump: _jumpToPage,
                        onCycleMode: _cycleMode,
                        onBookmark: () =>
                            toggleMushafBookmark(ref, _currentPage),
                      ),
                    ),
                  ),
                ),

                // ── Bottom bar (slides in from bottom) ────────────
                AnimatedSlide(
                  offset: _showOverlay ? Offset.zero : const Offset(0, 1),
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOut,
                  child: AnimatedOpacity(
                    opacity: _showOverlay ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: IgnorePointer(
                      ignoring: !_showOverlay,
                      child: _BottomBar(
                        currentPage: _currentPage,
                        sliderPage: _sliderPage,
                        mode: _mode,
                        zoom: _zoom,
                        onSliderChanged: (v) =>
                            setState(() => _sliderPage = v.round()),
                        onSliderEnd: (v) {
                          final p = v.round();
                          _pageCtrl.jumpToPage(p - 1);
                          _savePage(p);
                        },
                        onZoomIn: () => _adjustZoom(0.1),
                        onZoomOut: () => _adjustZoom(-0.1),
                        onReciter: _showReciterSheet,
                      ),
                    ),
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

// ─── Single Mushaf page (image + frame + shadow) ───────────────────────────────
class _MushafPage extends StatefulWidget {
  final int pageNumber;
  final MushafMode mode;
  final double zoom;
  final double turnFraction; // 0..0.5

  const _MushafPage({
    required this.pageNumber,
    required this.mode,
    required this.zoom,
    required this.turnFraction,
  });

  @override
  State<_MushafPage> createState() => _MushafPageState();
}

class _MushafPageState extends State<_MushafPage> {
  int _cdnIndex = 0;

  List<String> get _urls {
    final p = widget.pageNumber;
    final padded = p.toString().padLeft(3, '0');
    return [
      '${AppConstants.mushafCdnUrls[0]}/$p.jpg',         // qurancdn: 1.jpg
      '${AppConstants.mushafCdnUrls[1]}/page$padded.png', // github: page001.png
      '${AppConstants.mushafCdnUrls[2]}/page-$padded.jpg', // searchtruth: page-001.jpg
    ];
  }

  void _tryNext() {
    if (_cdnIndex < _urls.length - 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _cdnIndex++);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.mode;
    final isDark = mode == MushafMode.dark;

    // Edge shadow intensity based on turn fraction (simulates page peel)
    final turnShadow = sin(widget.turnFraction * pi) * 0.35;

    // Image.network is used instead of CachedNetworkImage to avoid
    // the disk-cache that permanently stores failure responses.
    Widget image = Image.network(
      _urls[_cdnIndex],
      key: ValueKey('${widget.pageNumber}_$_cdnIndex'),
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Shimmer.fromColors(
          baseColor:
              isDark ? const Color(0xFF1E2028) : const Color(0xFFEDE8DC),
          highlightColor:
              isDark ? const Color(0xFF282C38) : const Color(0xFFF8F5EE),
          child: Container(color: mode.pageBg),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        if (_cdnIndex < _urls.length - 1) {
          _tryNext();
          return Shimmer.fromColors(
            baseColor:
                isDark ? const Color(0xFF1E2028) : const Color(0xFFEDE8DC),
            highlightColor:
                isDark ? const Color(0xFF282C38) : const Color(0xFFF8F5EE),
            child: Container(color: mode.pageBg),
          );
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.signal_wifi_off_rounded,
                  size: 56,
                  color: isDark ? Colors.white24 : mode.gold.withAlpha(100)),
              const SizedBox(height: 12),
              Text(
                'تعذّر تحميل الصفحة\nتحقق من الاتصال بالإنترنت',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  color: isDark ? Colors.white38 : mode.subtext,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => setState(() => _cdnIndex = 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: mode.gold.withAlpha(isDark ? 40 : 25),
                    border: Border.all(
                        color: mode.gold.withAlpha(isDark ? 100 : 80),
                        width: 1),
                  ),
                  child: Text(
                    'إعادة المحاولة',
                    style: TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      color: mode.gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (mode.filter != null) {
      image = ColorFiltered(colorFilter: mode.filter!, child: image);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Transform.scale(
          scale: widget.zoom,
          child: Stack(
            children: [
              // Page with shadow (simulates physical book page)
              Container(
                decoration: BoxDecoration(
                  color: mode.pageBg,
                  boxShadow: [
                    BoxShadow(
                      color: mode.shadowColor,
                      blurRadius: 24,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: mode.shadowColor.withAlpha(60),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: image,
              ),

              // Spine shadow (left side = binding for RTL Mushaf)
              if (turnShadow > 0.01)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.center,
                          colors: [
                            Colors.black.withAlpha(
                                (turnShadow * 150).round()),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.25],
                        ),
                      ),
                    ),
                  ),
                ),

              // Islamic decorative frame overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _IslamicFramePainter(
                        mode.gold.withAlpha(isDark ? 80 : 110)),
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

// ─── Top bar ───────────────────────────────────────────────────────────────────
class _TopBar extends ConsumerWidget {
  final AsyncValue<MushafPageInfo?> info;
  final int currentPage;
  final MushafMode mode;
  final VoidCallback onBack;
  final VoidCallback onJump;
  final VoidCallback onCycleMode;
  final VoidCallback onBookmark;

  const _TopBar({
    required this.info,
    required this.currentPage,
    required this.mode,
    required this.onBack,
    required this.onJump,
    required this.onCycleMode,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(isPageBookmarkedProvider(currentPage));

    return Container(
      decoration: BoxDecoration(
        color: mode.barBg,
        border: Border(
          bottom: BorderSide(color: mode.divider, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: mode.shadowColor.withAlpha(80),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Thin gold top accent line
            Container(height: 2, color: mode.gold),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: Row(
                children: [
                  // Back button
                  _BarIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    color: mode.text,
                    onTap: onBack,
                  ),
                  // Surah + juz info
                  Expanded(
                    child: info.when(
                      data: (d) {
                        if (d == null) return const SizedBox.shrink();
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              d.surahName,
                              style: TextStyle(
                                fontFamily: 'AmiriQuran',
                                fontSize: 19,
                                color: mode.text,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                              ),
                              locale: const Locale('ar'),
                            ),
                            Text(
                              'الجزء ${ArabicUtils.toArabicNumerals(d.juzNumber)}',
                              style: TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                fontSize: 10,
                                color: mode.subtext,
                                height: 1.2,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ),
                  // Mode toggle
                  _BarIconButton(
                    icon: mode.icon,
                    color: mode.subtext,
                    onTap: onCycleMode,
                    tooltip: mode.label,
                  ),
                  // Bookmark
                  _BarIconButton(
                    icon: isBookmarked
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color: isBookmarked ? mode.gold : mode.subtext,
                    onTap: onBookmark,
                  ),
                  // Jump to page
                  _BarIconButton(
                    icon: Icons.tag_rounded,
                    color: mode.subtext,
                    onTap: onJump,
                    tooltip: 'انتقل',
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

// ─── Bottom bar ────────────────────────────────────────────────────────────────
class _BottomBar extends StatelessWidget {
  final int currentPage;
  final int sliderPage;
  final MushafMode mode;
  final double zoom;
  final ValueChanged<double> onSliderChanged;
  final ValueChanged<double> onSliderEnd;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onReciter;

  const _BottomBar({
    required this.currentPage,
    required this.sliderPage,
    required this.mode,
    required this.zoom,
    required this.onSliderChanged,
    required this.onSliderEnd,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReciter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: mode.barBg,
          border: Border(
            top: BorderSide(color: mode.divider, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: mode.shadowColor.withAlpha(80),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Page slider
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Row(
                  children: [
                    // Right page label (first page = 1 in RTL display)
                    Text(
                      ArabicUtils.toArabicNumerals(604),
                      style: TextStyle(
                          fontFamily: 'AmiriQuran',
                          fontSize: 11,
                          color: mode.subtext),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: mode.gold,
                          inactiveTrackColor: mode.divider,
                          thumbColor: mode.gold,
                          overlayColor: mode.gold.withAlpha(50),
                          trackHeight: 1.5,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14),
                        ),
                        child: Slider(
                          value: sliderPage.toDouble(),
                          min: 1,
                          max: 604,
                          onChanged: onSliderChanged,
                          onChangeEnd: onSliderEnd,
                        ),
                      ),
                    ),
                    Text(
                      ArabicUtils.toArabicNumerals(1),
                      style: TextStyle(
                          fontFamily: 'AmiriQuran',
                          fontSize: 11,
                          color: mode.subtext),
                    ),
                  ],
                ),
              ),

              // Action row: reciter | zoom out | page badge | zoom in | (spacer)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Reciter button
                    _BottomAction(
                      icon: Icons.headphones_rounded,
                      label: 'تلاوة',
                      color: mode.subtext,
                      onTap: onReciter,
                    ),

                    // Zoom out
                    _BottomAction(
                      icon: Icons.text_decrease_rounded,
                      label: 'أصغر',
                      color: zoom <= 0.85
                          ? mode.divider
                          : mode.subtext,
                      onTap: onZoomOut,
                    ),

                    // Current page badge (decorative, center)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: mode.gold, width: 1),
                        borderRadius: BorderRadius.circular(20),
                        color: mode.gold.withAlpha(20),
                      ),
                      child: Text(
                        ArabicUtils.toArabicNumerals(sliderPage),
                        style: TextStyle(
                          fontFamily: 'AmiriQuran',
                          fontSize: 16,
                          color: mode.text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // Zoom in
                    _BottomAction(
                      icon: Icons.text_increase_rounded,
                      label: 'أكبر',
                      color: zoom >= 1.6
                          ? mode.divider
                          : mode.subtext,
                      onTap: onZoomIn,
                    ),

                    // Placeholder for symmetry
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Thin gold bottom accent line
              Container(height: 2, color: mode.gold.withAlpha(100)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shared small widgets ──────────────────────────────────────────────────────

class _BarIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? tooltip;

  const _BarIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _BottomAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 9,
                  color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reciter bottom sheet ──────────────────────────────────────────────────────
class _ReciterSheet extends ConsumerWidget {
  final MushafMode mode;
  const _ReciterSheet({required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const reciters = AppConstants.reciters;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 8),
          width: 36,
          height: 3,
          decoration: BoxDecoration(
            color: mode.divider,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Title
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'اختر القارئ',
                style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: mode.text,
                ),
              ),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mode.gold,
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: mode.divider),
        // List
        for (final r in reciters)
          ListTile(
            onTap: () => Navigator.pop(context),
            leading: Icon(Icons.person_outline_rounded,
                color: mode.gold, size: 22),
            title: Text(
              r['name']!,
              style: TextStyle(
                fontFamily: 'NotoNaskhArabic',
                color: mode.text,
              ),
              textDirection: TextDirection.rtl,
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
