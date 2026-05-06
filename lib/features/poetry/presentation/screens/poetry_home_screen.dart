import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class _CatStyle {
  final List<Color> gradient;
  final Color accent;
  final String description;
  final IconData icon;
  final IconData bgIcon;
  const _CatStyle({
    required this.gradient,
    required this.accent,
    required this.description,
    required this.icon,
    required this.bgIcon,
  });
}

const _styles = <String, _CatStyle>{
  'madh': _CatStyle(
    gradient: [Color(0xFF1E0E44), Color(0xFF2A165C), Color(0xFF160A38)],
    accent: Color(0xFFD4AF37),
    description: 'في مدح النبي ﷺ وآله',
    icon: Icons.auto_awesome_rounded,
    bgIcon: Icons.mosque_rounded,
  ),
  'andalus': _CatStyle(
    gradient: [Color(0xFF0A1428), Color(0xFF112038), Color(0xFF070F1C)],
    accent: Color(0xFF7EC8E3),
    description: 'روائع الشعر الأندلسي',
    icon: Icons.nightlight_round,
    bgIcon: Icons.account_balance_rounded,
  ),
  'hikam': _CatStyle(
    gradient: [Color(0xFF1E1200), Color(0xFF342000), Color(0xFF140C00)],
    accent: Color(0xFFD4AF37),
    description: 'حكمة الأجداد وأمثالهم',
    icon: Icons.menu_book_rounded,
    bgIcon: Icons.local_library_rounded,
  ),
  'sabr': _CatStyle(
    gradient: [Color(0xFF071810), Color(0xFF0C2A18), Color(0xFF040E08)],
    accent: Color(0xFF52B788),
    description: 'في الصبر والرضا والتوكل',
    icon: Icons.eco_rounded,
    bgIcon: Icons.forest_rounded,
  ),
  'ibtihaal': _CatStyle(
    gradient: [Color(0xFF0C1020), Color(0xFF14182E), Color(0xFF070A14)],
    accent: Color(0xFFFFB347),
    description: 'نفحات روحانية خاشعة',
    icon: Icons.nights_stay_rounded,
    bgIcon: Icons.brightness_2_rounded,
  ),
};

const _defaultStyle = _CatStyle(
  gradient: [Color(0xFF1A1A2E), Color(0xFF0F0F23)],
  accent: AppColors.gold,
  description: '',
  icon: Icons.auto_stories_rounded,
  bgIcon: Icons.star_rounded,
);

class PoetryHomeScreen extends StatelessWidget {
  const PoetryHomeScreen({super.key});

  static const String _featuredVerse =
      'وَمَا نَيلُ المَطالِبِ بِالتَمَنِّي\nوَلكِن تُؤخَذُ الدُّنيا غِلابَا';
  static const String _featuredPoet = 'المتنبي';

  @override
  Widget build(BuildContext context) {
    final cats = AppConstants.poetryCategories;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF06070F),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildFeaturedCard()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
                  child: Row(
                    children: [
                      Container(
                        width: 3, height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'التصنيفات',
                        style: TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: _buildCategoryLayout(context, cats),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: const Icon(Icons.search_rounded, color: Colors.white60, size: 20),
          ),
          Column(
            children: [
              const Text(
                'المكتبة الشعرية',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'Poetry Library',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withOpacity(0.3),
                  letterSpacing: 1.8,
                ),
              ),
            ],
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildFeaturedCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF1A0A3E), Color(0xFF2E1870), Color(0xFF090515)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.gold.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E1870).withOpacity(0.5),
              blurRadius: 32, offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.auto_stories_outlined,
                    color: AppColors.gold.withOpacity(0.5), size: 18),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                  ),
                  child: const Text('قصيدة اليوم',
                      style: TextStyle(
                        fontFamily: 'NotoNaskhArabic', fontSize: 11, color: AppColors.gold)),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              '"$_featuredVerse"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Amiri', fontSize: 20, color: Colors.white,
                height: 2.2, fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(width: 28, height: 1, color: AppColors.gold.withOpacity(0.4)),
                const SizedBox(width: 8),
                Text(_featuredPoet,
                    style: TextStyle(
                      fontFamily: 'NotoNaskhArabic', fontSize: 13,
                      color: AppColors.gold.withOpacity(0.85),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryLayout(BuildContext context, List<Map<String, String>> cats) {
    // Pairs in rows, last item full-width if odd count
    final rows = <Widget>[];
    for (int i = 0; i < cats.length; i += 2) {
      final isLast = i + 1 >= cats.length;
      if (isLast) {
        rows.add(_CategoryCard(cat: cats[i], style: _styles[cats[i]['id']] ?? _defaultStyle,
            fullWidth: true));
      } else {
        rows.add(
          Row(
            children: [
              Expanded(child: _CategoryCard(
                  cat: cats[i + 1],
                  style: _styles[cats[i + 1]['id']] ?? _defaultStyle)),
              const SizedBox(width: 12),
              Expanded(child: _CategoryCard(
                  cat: cats[i],
                  style: _styles[cats[i]['id']] ?? _defaultStyle)),
            ],
          ),
        );
      }
      if (i + 2 < cats.length) rows.add(const SizedBox(height: 12));
    }
    return Column(children: rows);
  }
}

class _CategoryCard extends StatefulWidget {
  final Map<String, String> cat;
  final _CatStyle style;
  final bool fullWidth;

  const _CategoryCard({
    required this.cat,
    required this.style,
    this.fullWidth = false,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.style;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        context.push('/poetry/${widget.cat['id']}');
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 130),
        child: Container(
          height: widget.fullWidth ? 120 : 148,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: s.gradient,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: s.accent.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: s.gradient.first.withOpacity(0.6),
                blurRadius: 16, offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // ── Decorative large background icon ─────────────────────
                Positioned(
                  left: widget.fullWidth ? -10 : -16,
                  bottom: -16,
                  child: Icon(
                    s.bgIcon,
                    size: widget.fullWidth ? 110 : 120,
                    color: s.accent.withOpacity(0.07),
                  ),
                ),

                // ── Left-side fade overlay for text readability ───────────
                Positioned(
                  right: 0, top: 0, bottom: 0,
                  width: widget.fullWidth ? 220 : 130,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          s.gradient.last.withOpacity(0.0),
                          s.gradient.last.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Content ───────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Top row: icon square + arrow
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Arrow
                          Container(
                            width: 26, height: 26,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.arrow_back_ios_rounded,
                                color: Colors.white38, size: 13),
                          ),
                          // Icon square
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: s.accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: s.accent.withOpacity(0.35)),
                            ),
                            child: Icon(s.icon, color: s.accent, size: 22),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Category name + description
                      Text(
                        widget.cat['name']!,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.description,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          fontSize: 11,
                          color: s.accent.withOpacity(0.75),
                          height: 1.4,
                        ),
                        maxLines: 1,
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
