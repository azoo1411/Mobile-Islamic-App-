import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/adhkar_data.dart';
import '../providers/adhkar_provider.dart';

class AdhkarHomeScreen extends ConsumerWidget {
  const AdhkarHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counts = ref.watch(adhkarProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF06070F),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _CategoryCard(
                      category: adhkarCategories[i],
                      counts: counts,
                    ),
                    childCount: adhkarCategories.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'الأذكار',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Adhkar & Supplications',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.3),
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withOpacity(0.15),
                  AppColors.gold.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withOpacity(0.25)),
            ),
            child: const Text(
              '﴿ وَالذَّاكِرِينَ اللَّهَ كَثِيرًا وَالذَّاكِرَاتِ أَعَدَّ اللَّهُ لَهُم مَّغْفِرَةً وَأَجْرًا عَظِيمًا ﴾',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
                color: AppColors.gold,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final AdhkarCategory category;
  final AdhkarState counts;

  const _CategoryCard({required this.category, required this.counts});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final completed = cat.adhkar
        .asMap()
        .entries
        .where((e) => widget.counts.done('${cat.id}_${e.key}', e.value.count))
        .length;
    final total = cat.adhkar.length;
    final allDone = completed == total;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        context.push('/adhkar/${cat.id}');
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 130),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: cat.gradient,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: allDone
                  ? AppColors.gold.withOpacity(0.5)
                  : cat.accent.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: cat.gradient.first.withOpacity(0.6),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Decorative bg icon
                Positioned(
                  left: -16,
                  bottom: -16,
                  child: Icon(
                    cat.bgIcon,
                    size: 120,
                    color: cat.accent.withOpacity(0.07),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Arrow
                          Container(
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              allDone
                                  ? Icons.check_rounded
                                  : Icons.arrow_back_ios_rounded,
                              color: allDone ? AppColors.gold : Colors.white38,
                              size: 13,
                            ),
                          ),
                          // Icon
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: cat.accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: cat.accent.withOpacity(0.35)),
                            ),
                            child: Icon(cat.icon, color: cat.accent, size: 22),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Text(
                        cat.name,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cat.subtitle,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          fontSize: 10,
                          color: cat.accent.withOpacity(0.75),
                          height: 1.4,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      // Progress bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: total == 0 ? 0 : completed / total,
                                backgroundColor:
                                    Colors.white.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    allDone ? AppColors.gold : cat.accent),
                                minHeight: 3,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$completed/$total',
                            style: TextStyle(
                              fontFamily: 'NotoNaskhArabic',
                              fontSize: 10,
                              color: cat.accent.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
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
