import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/adhkar_data.dart';
import '../providers/adhkar_provider.dart';

class AdhkarDetailScreen extends ConsumerWidget {
  final String categoryId;

  const AdhkarDetailScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = adhkarCategories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => adhkarCategories.first,
    );
    final state = ref.watch(adhkarProvider);
    final completed = cat.adhkar
        .asMap()
        .entries
        .where((e) => state.done('${cat.id}_${e.key}', e.value.count))
        .length;
    final allDone = completed == cat.adhkar.length;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF06070F),
        appBar: AppBar(
          backgroundColor: cat.gradient[1],
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            cat.name,
            style: const TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded, size: 20),
              tooltip: 'إعادة تعيين',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      backgroundColor: const Color(0xFF12121E),
                      title: const Text(
                        'إعادة تعيين الأذكار',
                        style: TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      content: const Text(
                        'هل تريد إعادة تعيين جميع العدادات؟',
                        style: TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          color: Colors.white60,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('إلغاء',
                              style: TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                color: Colors.white54,
                              )),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('تعيين',
                              style: TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                color: AppColors.gold,
                              )),
                        ),
                      ],
                    ),
                  ),
                );
                if (confirm == true) {
                  ref.read(adhkarProvider.notifier).resetCategory(cat.id);
                }
              },
            ),
          ],
        ),

        // Completion banner
        body: Column(
          children: [
            if (allDone) _buildCompletionBanner(cat),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: cat.adhkar.length,
                itemBuilder: (ctx, i) {
                  final dhikr = cat.adhkar[i];
                  final key = '${cat.id}_$i';
                  final current = state.get(key);
                  final isDone = state.done(key, dhikr.count);
                  return _DhikrCard(
                    dhikr: dhikr,
                    current: current,
                    isDone: isDone,
                    accent: cat.accent,
                    gradient: cat.gradient,
                    onTap: () {
                      if (!isDone) {
                        ref.read(adhkarProvider.notifier).increment(key, dhikr.count);
                        HapticFeedback.lightImpact();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletionBanner(AdhkarCategory cat) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: AppColors.gold.withOpacity(0.15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.gold, size: 18),
          const SizedBox(width: 8),
          const Text(
            'أتممت جميع الأذكار — بارك الله فيك',
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              color: AppColors.gold,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single dhikr card ──────────────────────────────────────────────────────────

class _DhikrCard extends StatefulWidget {
  final Dhikr dhikr;
  final int current;
  final bool isDone;
  final Color accent;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _DhikrCard({
    required this.dhikr,
    required this.current,
    required this.isDone,
    required this.accent,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<_DhikrCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {
    if (widget.isDone) return;
    _pulse.forward().then((_) => _pulse.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final percent = widget.dhikr.count == 0
        ? 0.0
        : (widget.current / widget.dhikr.count).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: widget.isDone
                ? AppColors.gold.withOpacity(0.07)
                : Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.isDone
                  ? AppColors.gold.withOpacity(0.4)
                  : Colors.white.withOpacity(0.07),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Counter circle ────────────────────────────────────────
                Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 32,
                      lineWidth: 3,
                      percent: percent,
                      backgroundColor: Colors.white.withOpacity(0.08),
                      progressColor:
                          widget.isDone ? AppColors.gold : widget.accent,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: widget.isDone
                          ? Icon(Icons.check_rounded,
                              color: AppColors.gold, size: 22)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${widget.current}',
                                  style: TextStyle(
                                    color: widget.accent,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    height: 1,
                                  ),
                                ),
                                Container(
                                  height: 1,
                                  width: 20,
                                  color: widget.accent.withOpacity(0.4),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                ),
                                Text(
                                  '${widget.dhikr.count}',
                                  style: TextStyle(
                                    color: widget.accent.withOpacity(0.6),
                                    fontSize: 10,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                // ── Dhikr text ────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.dhikr.text,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 18,
                          height: 2.0,
                          color: widget.isDone
                              ? Colors.white.withOpacity(0.6)
                              : Colors.white,
                        ),
                      ),
                      if (widget.dhikr.source != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.dhikr.source!,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 11,
                            color: widget.accent.withOpacity(0.7),
                          ),
                        ),
                      ],
                      if (widget.dhikr.virtue != null) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: widget.accent.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: widget.accent.withOpacity(0.2)),
                          ),
                          child: Text(
                            widget.dhikr.virtue!,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: 'NotoNaskhArabic',
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: widget.accent.withOpacity(0.85),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
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
