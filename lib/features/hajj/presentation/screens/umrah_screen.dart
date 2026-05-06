import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/umrah_data.dart';

class UmrahScreen extends StatefulWidget {
  const UmrahScreen({super.key});

  @override
  State<UmrahScreen> createState() => _UmrahScreenState();
}

class _UmrahScreenState extends State<UmrahScreen> {
  // -1 = overview, 0-3 = ritual index, 4 = complete
  int _currentStep = -1;

  final List<List<bool>> _checkedSteps = List.generate(
    kUmrahRituals.length,
    (i) => List.filled(kUmrahRituals[i].steps.length, false),
  );

  void _goToStep(int index) {
    if (index < -1 || index > kUmrahRituals.length) return;
    setState(() => _currentStep = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStep == -1) return _buildStartScreen(context);
    if (_currentStep == kUmrahRituals.length) return _buildCompleteScreen(context);
    return _buildRitualScreen(context, _currentStep);
  }

  // ── Start / Overview ──────────────────────────────────────────────────────

  Widget _buildStartScreen(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D1A2E), Color(0xFF1A3050), Color(0xFF0D1A2E)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white60, size: 20),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        _UmrahHeroIcon(),
                        const SizedBox(height: 24),
                        const Text(
                          'مناسك العمرة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Umrah Guide',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.4),
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.gold.withOpacity(0.25)),
                          ),
                          child: const Text(
                            'دليلك الكامل لأداء العمرة خطوة بخطوة\nمن الإحرام حتى التحلل',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'NotoNaskhArabic',
                              fontSize: 14,
                              color: AppColors.gold,
                              height: 1.7,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Ritual overview tiles
                        ...List.generate(kUmrahRituals.length, (i) {
                          return _UmrahOverviewTile(
                            index: i,
                            ritual: kUmrahRituals[i],
                            onTap: () => _goToStep(i),
                          );
                        }),

                        const SizedBox(height: 28),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () => _goToStep(0),
                            icon: const Icon(Icons.play_arrow_rounded, size: 26),
                            label: const Text(
                              'ابدأ العمرة',
                              style: TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.gold,
                              foregroundColor: Colors.black87,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
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

  // ── Individual Ritual Screen ──────────────────────────────────────────────

  Widget _buildRitualScreen(BuildContext context, int index) {
    final ritual = kUmrahRituals[index];
    final checked = _checkedSteps[index];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF080E1C),
        body: SafeArea(
          child: Column(
            children: [
              _UmrahProgressHeader(
                current: index + 1,
                total: kUmrahRituals.length,
                ritual: ritual,
                onBack: () => _goToStep(index > 0 ? index - 1 : -1),
                onClose: () => _goToStep(-1),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      _UmrahVisualCard(ritual: ritual),
                      const SizedBox(height: 20),

                      // Step number badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: ritual.primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: ritual.accentColor.withOpacity(0.5)),
                            ),
                            child: Text(
                              'المنسك ${index + 1} من ${kUmrahRituals.length}',
                              style: TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                fontSize: 12,
                                color: ritual.accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Description
                      Text(
                        ritual.descriptionArabic,
                        style: TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.75),
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Checklist
                      _UmrahSectionLabel(label: 'خطوات المنسك', icon: Icons.checklist_rtl),
                      const SizedBox(height: 10),
                      ...List.generate(ritual.steps.length, (si) {
                        return _UmrahChecklistItem(
                          text: ritual.steps[si],
                          isChecked: checked[si],
                          accentColor: ritual.accentColor,
                          onTap: () => setState(() => checked[si] = !checked[si]),
                        );
                      }),
                      const SizedBox(height: 20),

                      // Tip
                      _UmrahTipCard(tip: ritual.importantTip, accentColor: ritual.accentColor),

                      // Dua
                      if (ritual.dua != null) ...[
                        const SizedBox(height: 16),
                        _UmrahDuaCard(ritual: ritual),
                      ],
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _UmrahBottomNav(
          isFirst: index == 0,
          isLast: index == kUmrahRituals.length - 1,
          onBack: () => _goToStep(index - 1),
          onNext: () => _goToStep(index + 1),
          accentColor: ritual.accentColor,
        ),
      ),
    );
  }

  // ── Completion Screen ─────────────────────────────────────────────────────

  Widget _buildCompleteScreen(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D1A2E), Color(0xFF1A3050)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🕌', style: TextStyle(fontSize: 80)),
                    const SizedBox(height: 24),
                    const Text(
                      'تقبّل الله عمرتك',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'اللهم تقبّل منا\nإنك أنت السميع العليم',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.9,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _UmrahStatBadge(
                          value: '${kUmrahRituals.length}',
                          label: 'منسك مكتمل',
                          color: AppColors.gold,
                        ),
                        const SizedBox(width: 20),
                        _UmrahStatBadge(
                          value: '${_checkedSteps.fold(0, (s, l) => s + l.where((c) => c).length)}',
                          label: 'خطوة تم تأشيرها',
                          color: const Color(0xFF52B788),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _goToStep(-1),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'العودة للبداية',
                          style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Sub-widgets
// ══════════════════════════════════════════════════════════════════════════════

class _UmrahHeroIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF1A3050),
        border: Border.all(color: AppColors.gold.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withOpacity(0.12),
            blurRadius: 30,
            spreadRadius: 8,
          ),
        ],
      ),
      child: const Center(
        child: Text('🕌', style: TextStyle(fontSize: 60)),
      ),
    );
  }
}

class _UmrahOverviewTile extends StatelessWidget {
  final int index;
  final UmrahRitual ritual;
  final VoidCallback onTap;

  const _UmrahOverviewTile({
    required this.index,
    required this.ritual,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: ritual.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ritual.accentColor.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: ritual.primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: ritual.accentColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ritual.titleArabic,
                    style: const TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    ritual.titleEnglish,
                    style: TextStyle(
                      fontSize: 11,
                      color: ritual.accentColor.withOpacity(0.7),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(ritual.icon, color: ritual.accentColor, size: 20),
          ],
        ),
      ),
    );
  }
}

class _UmrahProgressHeader extends StatelessWidget {
  final int current;
  final int total;
  final UmrahRitual ritual;
  final VoidCallback onBack;
  final VoidCallback onClose;

  const _UmrahProgressHeader({
    required this.current,
    required this.total,
    required this.ritual,
    required this.onBack,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF080E1C),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white60, size: 18),
                onPressed: onBack,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      ritual.titleArabic,
                      style: const TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'المنسك $current من $total',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.4),
                        fontFamily: 'NotoNaskhArabic',
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white38, size: 20),
                onPressed: onClose,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: current / total,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation<Color>(ritual.accentColor),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}

class _UmrahVisualCard extends StatelessWidget {
  final UmrahRitual ritual;
  const _UmrahVisualCard({required this.ritual});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        ritual.imagePath,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: ritual.primaryColor.withOpacity(0.3),
            border: Border.all(color: ritual.accentColor.withOpacity(0.3)),
          ),
          child: Icon(ritual.icon, color: ritual.accentColor, size: 48),
        ),
      ),
    );
  }
}

class _UmrahSectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;
  const _UmrahSectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.gold, size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'NotoNaskhArabic',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _UmrahChecklistItem extends StatelessWidget {
  final String text;
  final bool isChecked;
  final Color accentColor;
  final VoidCallback onTap;

  const _UmrahChecklistItem({
    required this.text,
    required this.isChecked,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isChecked
              ? accentColor.withOpacity(0.12)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isChecked
                ? accentColor.withOpacity(0.4)
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked ? accentColor : Colors.transparent,
                border: Border.all(
                  color: isChecked ? accentColor : Colors.white30,
                  width: 1.5,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 14,
                  color: isChecked
                      ? Colors.white.withOpacity(0.45)
                      : Colors.white.withOpacity(0.85),
                  decoration: isChecked ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.white38,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UmrahTipCard extends StatelessWidget {
  final String tip;
  final Color accentColor;
  const _UmrahTipCard({required this.tip, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💡', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تنبيه مهم',
                  style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip,
                  style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.75),
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UmrahDuaCard extends StatelessWidget {
  final UmrahRitual ritual;
  const _UmrahDuaCard({required this.ritual});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1A2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ritual.accentColor.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.format_quote, color: ritual.accentColor, size: 16),
              const SizedBox(width: 6),
              Text(
                'الدعاء',
                style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: ritual.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            ritual.dua!,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'AmiriQuran',
              fontSize: 18,
              color: Colors.white,
              height: 2.0,
            ),
          ),
          if (ritual.duaTransliteration != null) ...[
            const SizedBox(height: 8),
            Text(
              ritual.duaTransliteration!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.4),
                fontStyle: FontStyle.italic,
                height: 1.7,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _UmrahBottomNav extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final Color accentColor;

  const _UmrahBottomNav({
    required this.isFirst,
    required this.isLast,
    required this.onBack,
    required this.onNext,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF080E1C),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
      ),
      child: Row(
        children: [
          if (!isFirst)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_forward_ios, size: 14),
                label: const Text(
                  'السابق',
                  style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white60,
                  side: BorderSide(color: Colors.white.withOpacity(0.12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          if (!isFirst) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: onNext,
              icon: Icon(
                isLast ? Icons.check_circle_outline : Icons.arrow_back_ios,
                size: 16,
              ),
              label: Text(
                isLast ? 'إتمام العمرة' : 'التالي',
                style: const TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.black87,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UmrahStatBadge extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _UmrahStatBadge({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 11,
              color: Colors.white.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}
