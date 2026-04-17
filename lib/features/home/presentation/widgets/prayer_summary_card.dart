import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../prayer_times/presentation/providers/prayer_times_provider.dart';

class PrayerSummaryCard extends ConsumerWidget {
  const PrayerSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerState = ref.watch(prayerTimesProvider);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go('/prayer'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: prayerState.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (_, __) => _buildLocationError(context),
            data: (data) => _buildPrayerTimes(data),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimes(PrayerTimesData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data.locationName,
              style: AppTypography.bodySmall,
            ),
            Text(
              'أوقات الصلاة',
              style: AppTypography.heading3,
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildNextPrayer(data),
        const Divider(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: data.todayPrayers.entries
              .map((e) => _buildMiniPrayer(
                    e.key,
                    e.value,
                    isNext: e.key == data.nextPrayerName,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildNextPrayer(PrayerTimesData data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الوقت المتبقي', style: AppTypography.caption),
              Text(
                ArabicUtils.formatPrayerCountdown(data.timeUntilNext),
                style: AppTypography.prayerTime
                    .copyWith(fontSize: 24, color: AppColors.primary),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('الصلاة القادمة', style: AppTypography.caption),
              Text(
                ArabicUtils.prayerName(data.nextPrayerName),
                style: AppTypography.heading2.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPrayer(String name, String time, {bool isNext = false}) {
    return Column(
      children: [
        Text(
          ArabicUtils.prayerName(name),
          style: AppTypography.caption.copyWith(
            fontWeight: isNext ? FontWeight.w700 : FontWeight.normal,
            color: isNext ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          ArabicUtils.toArabicTime(time),
          style: TextStyle(
            fontFamily: 'NotoNaskhArabic',
            fontSize: 12,
            fontWeight: isNext ? FontWeight.w700 : FontWeight.normal,
            color: isNext ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
        if (isNext) ...[
          const SizedBox(height: 2),
          Container(
            height: 3,
            width: 3,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationError(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.location_off_outlined, color: AppColors.textSecondary),
        const SizedBox(height: 8),
        Text(
          'يرجى السماح بالوصول إلى موقعك لعرض أوقات الصلاة',
          style: AppTypography.bodySmall,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
      ],
    );
  }
}
