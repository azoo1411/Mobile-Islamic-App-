import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../database/app_database.dart';
import '../providers/poetry_provider.dart';
import 'poetry_immersive_reader.dart';

const _categoryGradients = <String, List<Color>>{
  'madh':     [Color(0xFF1A0A3E), Color(0xFF2E1870), Color(0xFF090515)],
  'andalus':  [Color(0xFF082030), Color(0xFF103858), Color(0xFF040E18)],
  'hikam':    [Color(0xFF1E1000), Color(0xFF3E2200), Color(0xFF0A0800)],
  'sabr':     [Color(0xFF071A10), Color(0xFF0E3020), Color(0xFF030A06)],
  'ibtihaal': [Color(0xFF1A0808), Color(0xFF380F0F), Color(0xFF0A0404)],
};

const _categoryAccents = <String, Color>{
  'madh':     Color(0xFFD4AF37),
  'andalus':  Color(0xFF7EC8E3),
  'hikam':    Color(0xFFD4AF37),
  'sabr':     Color(0xFF52B788),
  'ibtihaal': Color(0xFFFFB347),
};

class PoetryReaderScreen extends ConsumerWidget {
  final String categoryId;
  const PoetryReaderScreen({super.key, required this.categoryId});

  List<Color> get _gradient =>
      _categoryGradients[categoryId] ?? [const Color(0xFF1A1A2E), const Color(0xFF0F0F23)];

  Color get _accent => _categoryAccents[categoryId] ?? AppColors.gold;

  String get _categoryName => AppConstants.poetryCategories
      .firstWhere((c) => c['id'] == categoryId, orElse: () => {'name': 'قصائد'})['name']!;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poemsAsync = ref.watch(poetryCategoryProvider(categoryId));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF06070F),
        body: Stack(
          children: [
            // Subtle top gradient
            Positioned(
              top: 0, left: 0, right: 0,
              height: 220,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _gradient.first.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: poemsAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(color: AppColors.gold),
                      ),
                      error: (e, _) => Center(
                        child: Text('خطأ: $e',
                            style: const TextStyle(color: Colors.white54)),
                      ),
                      data: (poems) => poems.isEmpty
                          ? _buildEmpty()
                          : _buildPoemList(context, poems),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white70, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                _categoryName,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'Poetry Collection',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.35),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildPoemList(BuildContext context, List<Poem> poems) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      itemCount: poems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, i) => _PoemCard(
        poem: poems[i],
        index: i,
        accent: _accent,
        gradient: _gradient,
        onTap: () => Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => FadeTransition(
              opacity: animation,
              child: PoetryImmersiveReader(
                poem: poems[i],
                allPoems: poems,
                initialIndex: i,
                gradient: _gradient,
                accent: _accent,
                categoryName: _categoryName,
              ),
            ),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📖', style: TextStyle(fontSize: 56, color: Colors.white.withOpacity(0.3))),
          const SizedBox(height: 16),
          const Text(
            'لا توجد قصائد في هذا التصنيف',
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 16,
              color: Colors.white38,
            ),
          ),
        ],
      ),
    );
  }
}

class _PoemCard extends StatefulWidget {
  final Poem poem;
  final int index;
  final Color accent;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _PoemCard({
    required this.poem,
    required this.index,
    required this.accent,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_PoemCard> createState() => _PoemCardState();
}

class _PoemCardState extends State<_PoemCard> {
  bool _pressed = false;

  String get _previewVerse {
    final lines = widget.poem.poemText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .take(2)
        .join('\n');
    return lines.isEmpty ? widget.poem.poemText : lines;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 130),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.07)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Left accent bar
                Positioned(
                  left: 0, top: 0, bottom: 0,
                  width: 3,
                  child: Container(color: widget.accent.withOpacity(0.6)),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Title row
                      Row(
                        children: [
                          Icon(Icons.auto_stories_outlined,
                              color: widget.accent.withOpacity(0.5), size: 16),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.poem.title,
                                style: const TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.poem.poet,
                                style: TextStyle(
                                  fontFamily: 'NotoNaskhArabic',
                                  fontSize: 12,
                                  color: widget.accent.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),
                      Container(height: 1, color: Colors.white.withOpacity(0.06)),
                      const SizedBox(height: 14),

                      // Preview verse
                      Text(
                        _previewVerse,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.75),
                          height: 2.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Footer
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: widget.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'اقرأ القصيدة',
                              style: TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                fontSize: 10,
                                color: widget.accent,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (widget.poem.era != null)
                            Text(
                              widget.poem.era!,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                        ],
                      ),
                    ],
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
