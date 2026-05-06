import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';

class PoetryImmersiveReader extends StatefulWidget {
  final Poem poem;
  final List<Poem> allPoems;
  final int initialIndex;
  final List<Color> gradient;
  final Color accent;
  final String categoryName;

  const PoetryImmersiveReader({
    super.key,
    required this.poem,
    required this.allPoems,
    required this.initialIndex,
    required this.gradient,
    required this.accent,
    required this.categoryName,
  });

  @override
  State<PoetryImmersiveReader> createState() => _PoetryImmersiveReaderState();
}

class _PoetryImmersiveReaderState extends State<PoetryImmersiveReader>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late AnimationController _uiController;
  late Animation<double> _uiAnim;

  late List<String> _verses;
  int _currentVerse = 0;
  bool _focusMode = false;
  Timer? _uiTimer;

  @override
  void initState() {
    super.initState();
    _verses = _parseVerses(widget.poem.poemText);

    _pageController = PageController();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();

    _uiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
    _uiAnim = CurvedAnimation(parent: _uiController, curve: Curves.easeOut);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    _startUiTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _uiController.dispose();
    _uiTimer?.cancel();
    super.dispose();
  }

  static List<String> _parseVerses(String text) {
    final lines = text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (lines.isEmpty) return [text];
    final verses = <String>[];
    for (int i = 0; i < lines.length; i += 2) {
      if (i + 1 < lines.length) {
        verses.add('${lines[i]}\n${lines[i + 1]}');
      } else {
        verses.add(lines[i]);
      }
    }
    return verses;
  }

  void _startUiTimer() {
    _uiTimer?.cancel();
    if (_focusMode) return;
    _uiTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && !_focusMode) _uiController.reverse();
    });
  }

  void _onTap() {
    if (_focusMode) return;
    if (_uiController.value < 0.5) {
      _uiController.forward();
      _startUiTimer();
    } else {
      _startUiTimer();
    }
  }

  void _toggleFocus() {
    setState(() => _focusMode = !_focusMode);
    if (_focusMode) {
      _uiTimer?.cancel();
      _uiController.reverse();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      _uiController.forward();
      _startUiTimer();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _onPageChanged(int index) {
    _fadeController.reset();
    setState(() => _currentVerse = index);
    _fadeController.forward();
  }

  void _showInfoSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _InfoBottomSheet(
        poem: widget.poem,
        accent: widget.accent,
        gradient: widget.gradient,
      ),
    );
  }

  void _shareVerse() {
    final verse = _verses[_currentVerse];
    Clipboard.setData(ClipboardData(
      text: '$verse\n— ${widget.poem.poet} (${widget.poem.title})',
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ البيت',
            style: TextStyle(fontFamily: 'NotoNaskhArabic')),
        backgroundColor: widget.accent.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _onTap,
          onDoubleTap: _toggleFocus,
          child: Stack(
            children: [
              // ── Background gradient ──────────────────────────────────────
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: widget.gradient,
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Radial glow at center
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.75,
                      colors: [
                        widget.accent.withOpacity(0.04),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Verse PageView ───────────────────────────────────────────
              PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _verses.length,
                itemBuilder: (context, index) => _VerseScene(
                  verse: _verses[index],
                  verseIndex: index,
                  totalVerses: _verses.length,
                  accent: widget.accent,
                  fadeAnim: _fadeAnim,
                  isCurrent: index == _currentVerse,
                ),
              ),

              // ── Top bar ─────────────────────────────────────────────────
              Positioned(
                top: 0, left: 0, right: 0,
                child: FadeTransition(
                  opacity: _uiAnim,
                  child: SafeArea(
                    child: _TopBar(
                      title: widget.poem.title,
                      poet: widget.poem.poet,
                      accent: widget.accent,
                      focusMode: _focusMode,
                      onBack: () => Navigator.maybePop(context),
                      onFocus: _toggleFocus,
                      onShare: _shareVerse,
                    ),
                  ),
                ),
              ),

              // ── Bottom bar ──────────────────────────────────────────────
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: FadeTransition(
                  opacity: _uiAnim,
                  child: SafeArea(
                    child: _BottomBar(
                      currentVerse: _currentVerse,
                      totalVerses: _verses.length,
                      accent: widget.accent,
                      onPrev: _currentVerse > 0
                          ? () => _pageController.previousPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              )
                          : null,
                      onNext: _currentVerse < _verses.length - 1
                          ? () => _pageController.nextPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              )
                          : null,
                      onInfo: _showInfoSheet,
                    ),
                  ),
                ),
              ),

              // ── Focus mode hint ─────────────────────────────────────────
              if (_focusMode)
                Positioned(
                  top: 60,
                  left: 0, right: 0,
                  child: Center(
                    child: AnimatedOpacity(
                      opacity: _focusMode ? 0.45 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        'اضغط مرتين للخروج من وضع التركيز',
                        style: TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
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

// ──────────────────────────────────────────────────────────────────────────────
// Verse Scene
// ──────────────────────────────────────────────────────────────────────────────

class _VerseScene extends StatelessWidget {
  final String verse;
  final int verseIndex;
  final int totalVerses;
  final Color accent;
  final Animation<double> fadeAnim;
  final bool isCurrent;

  const _VerseScene({
    required this.verse,
    required this.verseIndex,
    required this.totalVerses,
    required this.accent,
    required this.fadeAnim,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: FadeTransition(
          opacity: isCurrent ? fadeAnim : const AlwaysStoppedAnimation(1.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Decorative top line
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 40, height: 1,
                      color: accent.withOpacity(0.3)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.star, color: accent.withOpacity(0.5), size: 10),
                  ),
                  Container(width: 40, height: 1,
                      color: accent.withOpacity(0.3)),
                ],
              ),
              const SizedBox(height: 32),

              // Verse number
              Text(
                '${verseIndex + 1}',
                style: TextStyle(
                  fontSize: 11,
                  color: accent.withOpacity(0.5),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),

              // Verse text
              Text(
                verse,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontFamily: 'AmiriQuran',
                  fontSize: 26,
                  color: Colors.white,
                  height: 2.4,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 32),

              // Decorative bottom line
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 40, height: 1,
                      color: accent.withOpacity(0.3)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.star, color: accent.withOpacity(0.5), size: 10),
                  ),
                  Container(width: 40, height: 1,
                      color: accent.withOpacity(0.3)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Top Bar
// ──────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final String title;
  final String poet;
  final Color accent;
  final bool focusMode;
  final VoidCallback onBack;
  final VoidCallback onFocus;
  final VoidCallback onShare;

  const _TopBar({
    required this.title,
    required this.poet,
    required this.accent,
    required this.focusMode,
    required this.onBack,
    required this.onFocus,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 24),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white70, size: 20),
            onPressed: onBack,
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                poet,
                style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 11,
                  color: accent.withOpacity(0.85),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              _IconBtn(
                icon: Icons.copy_rounded,
                onTap: onShare,
                color: Colors.white54,
              ),
              const SizedBox(width: 4),
              _IconBtn(
                icon: focusMode ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                onTap: onFocus,
                color: focusMode ? accent : Colors.white54,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Bottom Bar
// ──────────────────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final int currentVerse;
  final int totalVerses;
  final Color accent;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback onInfo;

  const _BottomBar({
    required this.currentVerse,
    required this.totalVerses,
    required this.accent,
    required this.onPrev,
    required this.onNext,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.75), Colors.transparent],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page dots
          _PageDots(
            current: currentVerse,
            total: totalVerses,
            accent: accent,
          ),
          const SizedBox(height: 16),

          // Navigation row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Info / lightbulb
              _IconBtn(
                icon: Icons.lightbulb_outline_rounded,
                onTap: onInfo,
                color: accent.withOpacity(0.7),
                size: 22,
              ),

              // Prev / Next
              Row(
                children: [
                  _NavButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    enabled: onPrev != null,
                    onTap: onPrev,
                    accent: accent,
                  ),
                  const SizedBox(width: 12),
                  // Counter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      '${currentVerse + 1} / $totalVerses',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                        fontFamily: 'NotoNaskhArabic',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _NavButton(
                    icon: Icons.arrow_back_ios_rounded,
                    enabled: onNext != null,
                    onTap: onNext,
                    accent: accent,
                  ),
                ],
              ),

              // Share placeholder (balanced)
              const SizedBox(width: 40),
            ],
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  final int current;
  final int total;
  final Color accent;

  const _PageDots({required this.current, required this.total, required this.accent});

  @override
  Widget build(BuildContext context) {
    // Show at most 9 dots; if more, show a compact progress bar
    if (total > 9) {
      return Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: (current + 1) / total,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(accent),
              minHeight: 2,
            ),
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? accent : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;
  final Color accent;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.25,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: enabled ? accent.withOpacity(0.15) : Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(
              color: enabled ? accent.withOpacity(0.4) : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Icon(icon, color: enabled ? accent : Colors.white38, size: 16),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double size;

  const _IconBtn({
    required this.icon,
    required this.onTap,
    required this.color,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Info Bottom Sheet
// ──────────────────────────────────────────────────────────────────────────────

class _InfoBottomSheet extends StatelessWidget {
  final Poem poem;
  final Color accent;
  final List<Color> gradient;

  const _InfoBottomSheet({
    required this.poem,
    required this.accent,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0E1120),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withOpacity(0.12),
                      border: Border.all(color: accent.withOpacity(0.3)),
                    ),
                    child: Icon(Icons.lightbulb_rounded, color: accent, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poem.title,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        poem.poet,
                        style: TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          fontSize: 13,
                          color: accent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Divider(color: Colors.white.withOpacity(0.07), height: 1),

            // Details
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (poem.era != null) ...[
                      _InfoRow(label: 'العصر', value: poem.era!, accent: accent),
                      const SizedBox(height: 12),
                    ],
                    if (poem.tags != null && poem.tags!.isNotEmpty) ...[
                      _InfoRow(label: 'التصنيف', value: poem.tags!, accent: accent),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      'نص القصيدة كاملاً',
                      style: TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      poem.poemText,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        height: 2.2,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Copy full poem
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                            text: '${poem.title}\n${poem.poet}\n\n${poem.poemText}',
                          ));
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('تم نسخ القصيدة',
                                  style: TextStyle(fontFamily: 'NotoNaskhArabic')),
                              backgroundColor: accent.withOpacity(0.9),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        },
                        icon: Icon(Icons.copy_rounded, size: 16, color: accent),
                        label: Text(
                          'نسخ القصيدة كاملة',
                          style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            color: accent,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: accent.withOpacity(0.4)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _InfoRow({required this.label, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontFamily: 'NotoNaskhArabic',
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: accent.withOpacity(0.8),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}
