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

// ─── Page metadata provider ───────────────────────────────────────────────────

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
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage.clamp(1, 604);
    _pageController = PageController(initialPage: _currentPage - 1);
    // Auto-resume only when opened from the default entry point
    if (widget.initialPage == 1) _loadLastPage();
  }

  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(AppConstants.prefLastMushafPage) ?? 1;
    if (saved > 1 && mounted) {
      _pageController.jumpToPage(saved - 1);
      setState(() => _currentPage = saved);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'استُؤنفت القراءة من صفحة ${ArabicUtils.toArabicNumerals(saved)}',
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
              setState(() => _currentPage = 1);
            },
          ),
        ),
      );
    }
  }

  Future<void> _savePage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(AppConstants.prefLastMushafPage, page);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    final info = ref.watch(mushafPageInfoProvider(_currentPage));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _showOverlay
          ? SystemUiOverlayStyle.light
          : const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
            ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF7F0),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _showOverlay = !_showOverlay),
          child: Stack(
            children: [
              // ── Pages ──────────────────────────────────────────
              PageView.builder(
                controller: _pageController,
                reverse: true, // RTL: swipe right = prev page
                itemCount: 604,
                onPageChanged: (i) {
                setState(() => _currentPage = i + 1);
                _savePage(i + 1);
              },
                itemBuilder: (_, i) => _MushafPageImage(pageNumber: i + 1),
              ),

              // ── Top bar ────────────────────────────────────────
              AnimatedOpacity(
                opacity: _showOverlay ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: IgnorePointer(
                  ignoring: !_showOverlay,
                  child: _TopOverlay(
                    info: info,
                    currentPage: _currentPage,
                    onBack: () => Navigator.pop(context),
                    onJump: _jumpToPage,
                    onBookmark: () => toggleMushafBookmark(ref, _currentPage),
                  ),
                ),
              ),

              // ── Bottom bar ─────────────────────────────────────
              AnimatedOpacity(
                opacity: _showOverlay ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: _BottomOverlay(currentPage: _currentPage),
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
  final VoidCallback onBack;
  final VoidCallback onJump;
  final VoidCallback onBookmark;
  const _TopOverlay({
    required this.info,
    required this.currentPage,
    required this.onBack,
    required this.onJump,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(isPageBookmarkedProvider(currentPage));

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.55), Colors.transparent],
          stops: const [0.0, 1.0],
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
              IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? const Color(0xFFD4AF37) : Colors.white,
                  size: 22,
                ),
                onPressed: onBookmark,
              ),
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

// ─── Bottom overlay ───────────────────────────────────────────────────────────

class _BottomOverlay extends StatelessWidget {
  final int currentPage;
  const _BottomOverlay({required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 28, top: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.5), Colors.transparent],
          ),
        ),
        child: Text(
          ArabicUtils.toArabicNumerals(currentPage),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'NotoNaskhArabic',
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ─── Single page image ────────────────────────────────────────────────────────

class _MushafPageImage extends StatelessWidget {
  final int pageNumber;
  const _MushafPageImage({required this.pageNumber});

  String get _url {
    final p = pageNumber.toString().padLeft(3, '0');
    return '${AppConstants.mushafImageBaseUrl}/page-$p.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: CachedNetworkImage(
        imageUrl: _url,
        fit: BoxFit.contain,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: const Color(0xFFEDE8DC),
          highlightColor: const Color(0xFFF8F5EE),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        errorWidget: (_, __, ___) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.menu_book_outlined,
                  size: 64, color: Color(0xFFD4AF37)),
              SizedBox(height: 12),
              Text(
                'تعذّر تحميل الصفحة',
                style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  color: Color(0xFF888888),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
