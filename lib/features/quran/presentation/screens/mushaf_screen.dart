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
                  reverse: false, // RTL Mushaf: swipe right-to-left = next page
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

// ─── Provider: ayahs for a Mushaf page (from local DB — no internet needed) ───
final mushafPageAyahsProvider =
    FutureProvider.family<List<Ayah>, int>((ref, page) async {
  final db = ref.watch(appDatabaseProvider);
  return db.quranDao.getAyahsByPage(page);
});

// ─── Single Mushaf page — rendered from local database ─────────────────────────
class _MushafPage extends ConsumerWidget {
  final int pageNumber;
  final MushafMode mode;
  final double zoom;
  final double turnFraction;

  const _MushafPage({
    required this.pageNumber,
    required this.mode,
    required this.zoom,
    required this.turnFraction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ayahsAsync = ref.watch(mushafPageAyahsProvider(pageNumber));
    final mode = this.mode;
    final isDark = mode == MushafMode.dark;
    final turnShadow = sin(turnFraction * pi) * 0.35;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Transform.scale(
          scale: zoom,
          child: Stack(
            children: [
              // ── Page card with shadow ─────────────────────────────
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: mode.pageBg,
                  boxShadow: [
                    BoxShadow(
                      color: mode.shadowColor,
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: mode.shadowColor.withAlpha(60),
                      blurRadius: 8,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: ayahsAsync.when(
                  loading: () => Shimmer.fromColors(
                    baseColor: isDark
                        ? const Color(0xFF1E2028)
                        : const Color(0xFFEDE8DC),
                    highlightColor: isDark
                        ? const Color(0xFF282C38)
                        : const Color(0xFFF8F5EE),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: Container(color: mode.pageBg),
                    ),
                  ),
                  error: (_, __) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: Center(
                      child: Text(
                        'خطأ في تحميل البيانات',
                        style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            color: mode.subtext),
                      ),
                    ),
                  ),
                  data: (ayahs) => _PageContent(
                    pageNumber: pageNumber,
                    ayahs: ayahs,
                    mode: mode,
                  ),
                ),
              ),

              // ── Spine shadow (page-turn effect) ───────────────────
              if (turnShadow > 0.01)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.center,
                          colors: [
                            Colors.black
                                .withAlpha((turnShadow * 150).round()),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.25],
                        ),
                      ),
                    ),
                  ),
                ),

              // ── Islamic decorative frame ──────────────────────────
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

// ─── Surah metadata (name, meccan, ayah count) ────────────────────────────────
typedef _SurahMeta = ({String name, bool meccan, int count});
const _surahMeta = <int, _SurahMeta>{
  1:  (name:'الفاتحة',     meccan:true,  count:7),
  2:  (name:'البقرة',      meccan:false, count:286),
  3:  (name:'آل عمران',   meccan:false, count:200),
  4:  (name:'النساء',      meccan:false, count:176),
  5:  (name:'المائدة',     meccan:false, count:120),
  6:  (name:'الأنعام',     meccan:true,  count:165),
  7:  (name:'الأعراف',     meccan:true,  count:206),
  8:  (name:'الأنفال',     meccan:false, count:75),
  9:  (name:'التوبة',      meccan:false, count:129),
  10: (name:'يونس',        meccan:true,  count:109),
  11: (name:'هود',         meccan:true,  count:123),
  12: (name:'يوسف',        meccan:true,  count:111),
  13: (name:'الرعد',       meccan:false, count:43),
  14: (name:'إبراهيم',     meccan:true,  count:52),
  15: (name:'الحجر',       meccan:true,  count:99),
  16: (name:'النحل',       meccan:true,  count:128),
  17: (name:'الإسراء',     meccan:true,  count:111),
  18: (name:'الكهف',       meccan:true,  count:110),
  19: (name:'مريم',        meccan:true,  count:98),
  20: (name:'طه',          meccan:true,  count:135),
  21: (name:'الأنبياء',    meccan:true,  count:112),
  22: (name:'الحج',        meccan:false, count:78),
  23: (name:'المؤمنون',    meccan:true,  count:118),
  24: (name:'النور',       meccan:false, count:64),
  25: (name:'الفرقان',     meccan:true,  count:77),
  26: (name:'الشعراء',     meccan:true,  count:227),
  27: (name:'النمل',       meccan:true,  count:93),
  28: (name:'القصص',       meccan:true,  count:88),
  29: (name:'العنكبوت',    meccan:true,  count:69),
  30: (name:'الروم',       meccan:true,  count:60),
  31: (name:'لقمان',       meccan:true,  count:34),
  32: (name:'السجدة',      meccan:true,  count:30),
  33: (name:'الأحزاب',     meccan:false, count:73),
  34: (name:'سبأ',         meccan:true,  count:54),
  35: (name:'فاطر',        meccan:true,  count:45),
  36: (name:'يس',          meccan:true,  count:83),
  37: (name:'الصافات',     meccan:true,  count:182),
  38: (name:'ص',           meccan:true,  count:88),
  39: (name:'الزمر',       meccan:true,  count:75),
  40: (name:'غافر',        meccan:true,  count:85),
  41: (name:'فصلت',        meccan:true,  count:54),
  42: (name:'الشورى',      meccan:true,  count:53),
  43: (name:'الزخرف',      meccan:true,  count:89),
  44: (name:'الدخان',      meccan:true,  count:59),
  45: (name:'الجاثية',     meccan:true,  count:37),
  46: (name:'الأحقاف',     meccan:true,  count:35),
  47: (name:'محمد',        meccan:false, count:38),
  48: (name:'الفتح',       meccan:false, count:29),
  49: (name:'الحجرات',     meccan:false, count:18),
  50: (name:'ق',           meccan:true,  count:45),
  51: (name:'الذاريات',    meccan:true,  count:60),
  52: (name:'الطور',       meccan:true,  count:49),
  53: (name:'النجم',       meccan:true,  count:62),
  54: (name:'القمر',       meccan:true,  count:55),
  55: (name:'الرحمن',      meccan:false, count:78),
  56: (name:'الواقعة',     meccan:true,  count:96),
  57: (name:'الحديد',      meccan:false, count:29),
  58: (name:'المجادلة',    meccan:false, count:22),
  59: (name:'الحشر',       meccan:false, count:24),
  60: (name:'الممتحنة',    meccan:false, count:13),
  61: (name:'الصف',        meccan:false, count:14),
  62: (name:'الجمعة',      meccan:false, count:11),
  63: (name:'المنافقون',   meccan:false, count:11),
  64: (name:'التغابن',     meccan:false, count:18),
  65: (name:'الطلاق',      meccan:false, count:12),
  66: (name:'التحريم',     meccan:false, count:12),
  67: (name:'الملك',       meccan:true,  count:30),
  68: (name:'القلم',       meccan:true,  count:52),
  69: (name:'الحاقة',      meccan:true,  count:52),
  70: (name:'المعارج',     meccan:true,  count:44),
  71: (name:'نوح',         meccan:true,  count:28),
  72: (name:'الجن',        meccan:true,  count:28),
  73: (name:'المزمل',      meccan:true,  count:20),
  74: (name:'المدثر',      meccan:true,  count:56),
  75: (name:'القيامة',     meccan:true,  count:40),
  76: (name:'الإنسان',     meccan:false, count:31),
  77: (name:'المرسلات',    meccan:true,  count:50),
  78: (name:'النبأ',       meccan:true,  count:40),
  79: (name:'النازعات',    meccan:true,  count:46),
  80: (name:'عبس',         meccan:true,  count:42),
  81: (name:'التكوير',     meccan:true,  count:29),
  82: (name:'الانفطار',    meccan:true,  count:19),
  83: (name:'المطففين',    meccan:true,  count:36),
  84: (name:'الانشقاق',    meccan:true,  count:25),
  85: (name:'البروج',      meccan:true,  count:22),
  86: (name:'الطارق',      meccan:true,  count:17),
  87: (name:'الأعلى',      meccan:true,  count:19),
  88: (name:'الغاشية',     meccan:true,  count:26),
  89: (name:'الفجر',       meccan:true,  count:30),
  90: (name:'البلد',       meccan:true,  count:20),
  91: (name:'الشمس',       meccan:true,  count:15),
  92: (name:'الليل',       meccan:true,  count:21),
  93: (name:'الضحى',       meccan:true,  count:11),
  94: (name:'الشرح',       meccan:true,  count:8),
  95: (name:'التين',       meccan:true,  count:8),
  96: (name:'العلق',       meccan:true,  count:19),
  97: (name:'القدر',       meccan:true,  count:5),
  98: (name:'البينة',      meccan:false, count:8),
  99: (name:'الزلزلة',     meccan:false, count:8),
  100:(name:'العاديات',    meccan:true,  count:11),
  101:(name:'القارعة',     meccan:true,  count:11),
  102:(name:'التكاثر',     meccan:true,  count:8),
  103:(name:'العصر',       meccan:true,  count:3),
  104:(name:'الهمزة',      meccan:true,  count:9),
  105:(name:'الفيل',       meccan:true,  count:5),
  106:(name:'قريش',        meccan:true,  count:4),
  107:(name:'الماعون',     meccan:true,  count:7),
  108:(name:'الكوثر',      meccan:true,  count:3),
  109:(name:'الكافرون',    meccan:true,  count:6),
  110:(name:'النصر',       meccan:false, count:3),
  111:(name:'المسد',       meccan:true,  count:5),
  112:(name:'الإخلاص',     meccan:true,  count:4),
  113:(name:'الفلق',       meccan:true,  count:5),
  114:(name:'الناس',       meccan:true,  count:6),
};

// ─── Page content: renders Quran text from local database ─────────────────────
class _PageContent extends StatelessWidget {
  final int pageNumber;
  final List<Ayah> ayahs;
  final MushafMode mode;

  const _PageContent({
    required this.pageNumber,
    required this.ayahs,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    if (ayahs.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.82,
        child: Center(
          child: Text(
            ArabicUtils.toArabicNumerals(pageNumber),
            style: TextStyle(
                fontFamily: 'AmiriQuran', color: mode.subtext, fontSize: 24),
          ),
        ),
      );
    }

    final juz = ayahs.first.juzNumber;
    final firstSurah = ayahs.first.surahNumber;
    final meta = _surahMeta[firstSurah];

    // Group ayahs by surah
    final surahGroups = <int, List<Ayah>>{};
    for (final a in ayahs) {
      surahGroups.putIfAbsent(a.surahNumber, () => []).add(a);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Top Mushaf page header (like real Mushaf) ─────────────
        _PageTopBar(
          surahName: meta?.name ?? '',
          juz: juz,
          mode: mode,
        ),
        Container(height: 0.6, color: mode.gold.withAlpha(100)),

        // ── Content area ──────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final entry in surahGroups.entries) ...[
                    if (entry.value.first.ayahNumber == 1)
                      _SurahBand(surahNumber: entry.key, mode: mode),
                    if (entry.value.first.ayahNumber == 1 &&
                        entry.key != 1 &&
                        entry.key != 9)
                      _BasmalaLine(mode: mode),
                    _AyahBlock(ayahs: entry.value, mode: mode),
                    if (entry.key != surahGroups.keys.last)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                            height: 0.5,
                            color: mode.gold.withAlpha(60)),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // ── Bottom: page number ───────────────────────────────────
        Container(height: 0.6, color: mode.gold.withAlpha(100)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Text(
              ArabicUtils.toArabicNumerals(pageNumber),
              style: TextStyle(
                fontFamily: 'AmiriQuran',
                fontSize: 14,
                color: mode.gold.withAlpha(200),
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Top bar inside each Mushaf page ──────────────────────────────────────────
class _PageTopBar extends StatelessWidget {
  final String surahName;
  final int juz;
  final MushafMode mode;
  const _PageTopBar(
      {required this.surahName, required this.juz, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'الجزء ${ArabicUtils.toArabicNumerals(juz)}',
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 11,
              color: mode.subtext,
            ),
          ),
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: mode.gold.withAlpha(140),
            ),
          ),
          Text(
            surahName.isNotEmpty ? 'سورة $surahName' : '',
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 11,
              color: mode.subtext,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Decorative surah header band ─────────────────────────────────────────────
class _SurahBand extends StatelessWidget {
  final int surahNumber;
  final MushafMode mode;
  const _SurahBand({required this.surahNumber, required this.mode});

  @override
  Widget build(BuildContext context) {
    final meta = _surahMeta[surahNumber];
    final name = meta?.name ?? '$surahNumber';
    final type = (meta?.meccan ?? true) ? 'مكية' : 'مدنية';
    final count = meta?.count ?? 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: mode.gold.withAlpha(12),
        border: Border(
          top: BorderSide(color: mode.gold.withAlpha(160), width: 1.2),
          bottom: BorderSide(color: mode.gold.withAlpha(160), width: 1.2),
        ),
      ),
      child: Column(
        children: [
          // Decorative dots row
          _OrnamentRow(mode: mode),
          const SizedBox(height: 4),
          // Surah name
          Text(
            'سورة $name',
            style: TextStyle(
              fontFamily: 'AmiriQuran',
              fontSize: 20,
              color: mode.text,
              height: 1.6,
            ),
            locale: const Locale('ar'),
          ),
          // Type + ayah count
          Text(
            '$type  •  ${ArabicUtils.toArabicNumerals(count)} آية',
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 11,
              color: mode.subtext,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          _OrnamentRow(mode: mode),
        ],
      ),
    );
  }
}

class _OrnamentRow extends StatelessWidget {
  final MushafMode mode;
  const _OrnamentRow({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(height: 0.6, width: 60, color: mode.gold.withAlpha(100)),
        const SizedBox(width: 6),
        _dot(mode),
        const SizedBox(width: 4),
        _dot(mode, large: true),
        const SizedBox(width: 4),
        _dot(mode),
        const SizedBox(width: 6),
        Container(height: 0.6, width: 60, color: mode.gold.withAlpha(100)),
      ],
    );
  }

  Widget _dot(MushafMode m, {bool large = false}) => Container(
        width: large ? 5 : 3,
        height: large ? 5 : 3,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: m.gold.withAlpha(large ? 180 : 120),
        ),
      );
}

// ─── Basmala ──────────────────────────────────────────────────────────────────
class _BasmalaLine extends StatelessWidget {
  final MushafMode mode;
  const _BasmalaLine({required this.mode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        locale: const Locale('ar'),
        style: TextStyle(
          fontFamily: 'AmiriQuran',
          fontSize: 21,
          color: mode.gold,
          height: 2.0,
          fontFeatures: const [
            FontFeature.enable('calt'),
            FontFeature.enable('liga'),
          ],
        ),
      ),
    );
  }
}

// ─── Ayah text block ──────────────────────────────────────────────────────────
class _AyahBlock extends StatelessWidget {
  final List<Ayah> ayahs;
  final MushafMode mode;
  const _AyahBlock({required this.ayahs, required this.mode});

  @override
  Widget build(BuildContext context) {
    final spans = <TextSpan>[];
    for (final ayah in ayahs) {
      spans.add(TextSpan(text: '${ayah.textUthmani} '));
      spans.add(TextSpan(
        text: '۝${ArabicUtils.toArabicNumerals(ayah.ayahNumber)} ',
        style: TextStyle(
          fontSize: 13,
          color: mode.gold,
          fontFamily: 'AmiriQuran',
        ),
      ));
    }

    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontFamily: 'AmiriQuran',
          fontSize: 19,
          height: 2.5,
          color: mode.text,
          fontFeatures: const [
            FontFeature.enable('calt'),
            FontFeature.enable('liga'),
            FontFeature.enable('clig'),
          ],
        ),
        children: spans,
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.justify,
      locale: const Locale('ar'),
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
