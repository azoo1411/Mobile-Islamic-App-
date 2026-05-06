import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class _CatMeta {
  final List<Color> gradient;
  final Color accent;
  final String description;
  const _CatMeta({required this.gradient, required this.accent, required this.description});
}

class PoetryHomeScreen extends StatelessWidget {
  const PoetryHomeScreen({super.key});

  static const _meta = <String, _CatMeta>{
    'madh': _CatMeta(
      gradient: [Color(0xFF1A0A3E), Color(0xFF2E1870)],
      accent: Color(0xFFD4AF37),
      description: 'في مدح النبي ﷺ وآله',
    ),
    'andalus': _CatMeta(
      gradient: [Color(0xFF082030), Color(0xFF103858)],
      accent: Color(0xFF7EC8E3),
      description: 'روائع الشعر الأندلسي',
    ),
    'hikam': _CatMeta(
      gradient: [Color(0xFF1E1000), Color(0xFF3E2200)],
      accent: Color(0xFFD4AF37),
      description: 'حكمة الأجداد وأمثالهم',
    ),
    'sabr': _CatMeta(
      gradient: [Color(0xFF071A10), Color(0xFF0E3020)],
      accent: Color(0xFF52B788),
      description: 'في الصبر والرضا والتوكل',
    ),
    'ibtihaal': _CatMeta(
      gradient: [Color(0xFF1A0808), Color(0xFF380F0F)],
      accent: Color(0xFFFFB347),
      description: 'نفحات روحانية خاشعة',
    ),
  };

  static const _featuredVerse =
      'وَمَا نَيلُ المَطالِبِ بِالتَمَنِّي\nوَلكِن تُؤخَذُ الدُّنيا غِلابَا';
  static const _featuredPoet = 'المتنبي';

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                  child: Row(
                    children: [
                      Container(width: 3, height: 18, decoration: BoxDecoration(
                        color: AppColors.gold,
                        borderRadius: BorderRadius.circular(2),
                      )),
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
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final cat = AppConstants.poetryCategories[i];
                      final m = _meta[cat['id']] ??
                          const _CatMeta(
                            gradient: [Color(0xFF1A1A2E), Color(0xFF0F0F23)],
                            accent: AppColors.gold,
                            description: '',
                          );
                      return _CategoryCard(cat: cat, meta: m);
                    },
                    childCount: AppConstants.poetryCategories.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
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
                  color: Colors.white.withOpacity(0.35),
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
              blurRadius: 32,
              offset: const Offset(0, 12),
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
                  child: const Text(
                    'قصيدة اليوم',
                    style: TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 11,
                      color: AppColors.gold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              '"$_featuredVerse"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                color: Colors.white,
                height: 2.2,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Container(width: 28, height: 1, color: AppColors.gold.withOpacity(0.4)),
                const SizedBox(width: 8),
                Text(
                  _featuredPoet,
                  style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 13,
                    color: AppColors.gold.withOpacity(0.85),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final Map<String, String> cat;
  final _CatMeta meta;
  const _CategoryCard({required this.cat, required this.meta});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        context.push('/poetry/${widget.cat['id']}');
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: widget.meta.gradient,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.meta.accent.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: widget.meta.gradient.last.withOpacity(0.5),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.arrow_back_ios_rounded,
                        color: widget.meta.accent.withOpacity(0.4), size: 13),
                    Text(widget.cat['icon'] ?? '📖',
                        style: const TextStyle(fontSize: 30)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.cat['name']!,
                      style: const TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.meta.description,
                      style: TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 11,
                        color: widget.meta.accent.withOpacity(0.7),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
