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

// ─── Reading mode ──────────────────────────────────────────────────────────────
enum MushafMode { white, sepia, dark }

extension _MushafModeX on MushafMode {
  Color get background => switch (this) {
        MushafMode.white => const Color(0xFFFAF8F0),
        MushafMode.sepia => const Color(0xFFEEDFBB),
        MushafMode.dark  => const Color(0xFF18181B),
      };

  Color get overlayBg => switch (this) {
        MushafMode.white => const Color(0xFFF0EAD6),
        MushafMode.sepia => const Color(0xFFE8D9AC),
        MushafMode.dark  => const Color(0xFF1F1F24),
      };

  Color get textColor => switch (this) {
        MushafMode.white => const Color(0xFF1A1208),
        MushafMode.sepia => const Color(0xFF2D1B0E),
        MushafMode.dark  => const Color(0xFFE8DCC8),
      };

  Color get subtextColor => switch (this) {
        MushafMode.white => const Color(0xFF5C4A2A),
        MushafMode.sepia => const Color(0xFF5C4A2A),
        MushafMode.dark  => const Color(0xFFAA9070),
      };

  Color get borderColor => switch (this) {
        MushafMode.white => const Color(0xFFC8A820),
        MushafMode.sepia => const Color(0xFFA88618),
        MushafMode.dark  => const Color(0xFF5A4A28),
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

// ─── Screen ────────────────────────────────────────────────────────────────────
class MushafScreen extends ConsumerStatefulWidget {
  final int initialPage;
  const MushafScreen({super.key, this.initialPage = 1});

  @override
  ConsumerState<MushafScreen> createState() => _MushafScreenState();
}

class _MushafScreenState extends ConsumerState<MushafScreen> {
  late PageController _pageController;
  late int _currentPage;
  int _sliderPage = 1;
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
    final modeStr = prefs.getString(_prefMode) ?? 'white';
    final mode = MushafMode.values.firstWhere(
      (m) => m.name == modeStr,
      orElse: () => MushafMode.white,
    );
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
          textColor: const Color(0xFFC8A820),
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
        backgroundColor: _mode.overlayBg,
        title: Text('انتقل إلى صفحة',
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontFamily: 'NotoNaskhArabic', color: _mode.textColor)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: TextStyle(color: _mode.textColor),
          decoration: InputDecoration(
            hintText: '١ – ٦٠٤',
            hintStyle: TextStyle(color: _mode.subtextColor),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: _mode.borderColor),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء',
                style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    color: _mode.subtextColor)),
          ),
          TextButton(
            onPressed: () {
              final p = int.tryParse(controller.text);
              if (p != null && p >= 1 && p <= 604) Navigator.pop(context, p);
            },
            child: Text('انتقال',
                style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    color: const Color(0xFF1B4D3E))),
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
    final isDark = _mode == MushafMode.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _mode.background,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _showOverlay = !_showOverlay),
          child: Stack(
            children: [
              // ── Pages ───────────────────────────────────────────
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

              // ── Top overlay ──────────────────────────────────────
              AnimatedOpacity(
                opacity: _showOverlay ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 220),
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

              // ── Bottom overlay ───────────────────────────────────
              AnimatedOpacity(
                opacity: _showOverlay ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 220),
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

// ─── Top overlay ───────────────────────────────────────────────────────────────
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
          colors: [
            mode.overlayBg.withOpacity(0.97),
            mode.overlayBg.withOpacity(0.0),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decorative top border line
            Container(
              height: 1.5,
              color: mode.borderColor.withOpacity(0.5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                children: [
                  // Back
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_new,
                        color: mode.textColor, size: 19),
                    onPressed: onBack,
                  ),
                  // Center info
                  Expanded(
                    child: info.when(
                      data: (d) => d == null
                          ? const SizedBox.shrink()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  d.surahName,
                                  style: TextStyle(
                                    fontFamily: 'AmiriQuran',
                                    fontSize: 18,
                                    color: mode.textColor,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5,
                                  ),
                                  locale: const Locale('ar'),
                                ),
                                Text(
                                  'الجزء ${ArabicUtils.toArabicNumerals(d.juzNumber)}',
                                  style: TextStyle(
                                    fontFamily: 'NotoNaskhArabic',
                                    fontSize: 11,
                                    color: mode.subtextColor,
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
                    icon: Icon(mode.icon, color: mode.textColor, size: 19),
                    tooltip: mode.label,
                    onPressed: onCycleMode,
                  ),
                  // Bookmark
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked
                          ? const Color(0xFFC8A820)
                          : mode.textColor,
                      size: 21,
                    ),
                    onPressed: onBookmark,
                  ),
                  // Jump
                  IconButton(
                    icon: Icon(Icons.find_in_page_outlined,
                        color: mode.textColor, size: 21),
                    onPressed: onJump,
                  ),
                ],
              ),
            ),
            // Decorative bottom border line under the controls
            Container(
              height: 1,
              color: mode.borderColor.withOpacity(0.25),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom overlay ────────────────────────────────────────────────────────────
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              mode.overlayBg.withOpacity(0.97),
              mode.overlayBg.withOpacity(0.0),
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Decorative top border line
              Container(
                height: 1,
                color: mode.borderColor.withOpacity(0.25),
              ),
              const SizedBox(height: 4),
              // Page number in decorative box
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                decoration: BoxDecoration(
                  color: mode.borderColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: mode.borderColor.withOpacity(0.35), width: 1),
                ),
                child: Text(
                  ArabicUtils.toArabicNumerals(sliderPage),
                  style: TextStyle(
                    fontFamily: 'AmiriQuran',
                    fontSize: 14,
                    color: mode.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFC8A820),
                  inactiveTrackColor: mode.borderColor.withOpacity(0.2),
                  thumbColor: const Color(0xFFC8A820),
                  overlayColor: const Color(0x33C8A820),
                  trackHeight: 1.5,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 5.5),
                  overlayShape:
                      const RoundSliderOverlayShape(overlayRadius: 13),
                ),
                child: Slider(
                  value: sliderPage.toDouble(),
                  min: 1,
                  max: 604,
                  onChanged: onSliderChanged,
                  onChangeEnd: onSliderEnd,
                ),
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Single page image (multi-CDN fallback) ────────────────────────────────────
class _MushafPageImage extends StatefulWidget {
  final int pageNumber;
  final MushafMode mode;
  const _MushafPageImage({required this.pageNumber, required this.mode});

  @override
  State<_MushafPageImage> createState() => _MushafPageImageState();
}

class _MushafPageImageState extends State<_MushafPageImage> {
  int _cdnIndex = 0;

  List<String> get _urls {
    final p = widget.pageNumber;
    final padded = p.toString().padLeft(3, '0');
    return [
      '${AppConstants.mushafCdnUrls[0]}/$p.jpg',
      '${AppConstants.mushafCdnUrls[1]}/page-$padded.jpg',
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

    Widget image = CachedNetworkImage(
      key: ValueKey('${widget.pageNumber}_$_cdnIndex'),
      imageUrl: _urls[_cdnIndex],
      fit: BoxFit.contain,
      placeholder: (_, __) => Shimmer.fromColors(
        baseColor: isDark
            ? const Color(0xFF2A2A2F)
            : const Color(0xFFEDE8DC),
        highlightColor: isDark
            ? const Color(0xFF3A3A40)
            : const Color(0xFFF8F5EE),
        child: Container(color: mode.background),
      ),
      errorWidget: (_, __, ___) {
        if (_cdnIndex < _urls.length - 1) {
          _tryNext();
          return Shimmer.fromColors(
            baseColor: isDark
                ? const Color(0xFF2A2A2F)
                : const Color(0xFFEDE8DC),
            highlightColor: isDark
                ? const Color(0xFF3A3A40)
                : const Color(0xFFF8F5EE),
            child: Container(color: mode.background),
          );
        }
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book_outlined,
                  size: 64,
                  color: isDark
                      ? Colors.white24
                      : const Color(0xFFC8A820).withOpacity(0.4)),
              const SizedBox(height: 12),
              Text(
                'تعذّر تحميل الصفحة\nتحقق من الاتصال بالإنترنت',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  color: isDark ? Colors.white38 : const Color(0xFF9E8866),
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

    // Subtle inner shadow to simulate page edges
    return Container(
      color: mode.background,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: image,
      ),
    );
  }
}
