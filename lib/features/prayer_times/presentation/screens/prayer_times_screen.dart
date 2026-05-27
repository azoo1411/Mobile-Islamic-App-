import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../../services/notification_service.dart';
import '../providers/prayer_times_provider.dart';

class PrayerTimesScreen extends ConsumerStatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  ConsumerState<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends ConsumerState<PrayerTimesScreen> {
  Timer? _timer;
  Duration _countdown = Duration.zero;
  bool _notificationsEnabled = true;
  bool _notificationsScheduled = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          if (_countdown.inSeconds > 0) {
            _countdown -= const Duration(seconds: 1);
          }
        });
      }
    });
    _loadNotificationPref();
  }

  Future<void> _loadNotificationPref() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _notificationsEnabled =
            prefs.getBool(AppConstants.prefNotificationsEnabled) ?? true;
      });
    }
  }

  Future<void> _toggleNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final next = !_notificationsEnabled;
    await prefs.setBool(AppConstants.prefNotificationsEnabled, next);
    setState(() => _notificationsEnabled = next);

    if (!next) {
      await NotificationService.instance.cancelAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إيقاف إشعارات الصلاة')),
        );
      }
    } else {
      // Re-schedule from current data
      _notificationsScheduled = false;
      ref.invalidate(prayerTimesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تفعيل إشعارات الصلاة')),
        );
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prayerAsync = ref.watch(prayerTimesProvider);

    // ── Schedule notifications whenever fresh data arrives ──
    ref.listen(prayerTimesProvider, (_, next) {
      next.whenData((data) {
        if (!_notificationsScheduled && _notificationsEnabled) {
          _notificationsScheduled = true;
          NotificationService.instance.schedulePrayerNotifications(
            prayerTimes: {
              'fajr':    data.prayerTimes.fajr,
              'dhuhr':   data.prayerTimes.dhuhr,
              'asr':     data.prayerTimes.asr,
              'maghrib': data.prayerTimes.maghrib,
              'isha':    data.prayerTimes.isha,
            },
          );
        }
      });
    });

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('أوقات الصلاة'),
          actions: [
            // Notification bell toggle
            IconButton(
              icon: Icon(
                _notificationsEnabled
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_off_outlined,
              ),
              onPressed: _toggleNotifications,
              tooltip: _notificationsEnabled ? 'إيقاف الإشعارات' : 'تفعيل الإشعارات',
            ),
            IconButton(
              icon: const Icon(Icons.explore_outlined),
              onPressed: () => context.push('/qibla'),
              tooltip: 'اتجاه القبلة',
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => _showCalculationMethodSheet(context),
              tooltip: 'طريقة الحساب',
            ),
          ],
        ),
        body: prayerAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => _buildError(context, e.toString()),
          data: (data) {
            if (_countdown == Duration.zero) {
              _countdown = data.timeUntilNext;
            }
            return _buildBody(data);
          },
        ),
      ),
    );
  }

  Widget _buildBody(PrayerTimesData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildNextPrayerCard(data),
          const SizedBox(height: 20),
          _buildPrayersList(data),
          const SizedBox(height: 16),
          _buildLocationInfo(data),
          if (!_notificationsEnabled) ...[  
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_off, color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'إشعارات الصلاة مُعطَّلة — اضغط على 🔔 لتفعيلها',
                      style: TextStyle(fontFamily: 'NotoNaskhArabic', fontSize: 13, color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNextPrayerCard(PrayerTimesData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            'الصلاة القادمة',
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ArabicUtils.prayerName(data.nextPrayerName),
            style: const TextStyle(
              fontFamily: 'NotoNaskhArabic',
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            ArabicUtils.formatPrayerCountdown(_countdown),
            style: AppTypography.prayerTime.copyWith(
              color: AppColors.gold,
              fontSize: 42,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'الوقت المتبقي',
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayersList(PrayerTimesData data) {
    final prayerColors = {
      'fajr':    AppColors.fajr,
      'dhuhr':   AppColors.dhuhr,
      'asr':     AppColors.asr,
      'maghrib': AppColors.maghrib,
      'isha':    AppColors.isha,
    };

    return Column(
      children: data.todayPrayers.entries.map((entry) {
        final isNext = entry.key == data.nextPrayerName;
        final color  = prayerColors[entry.key] ?? AppColors.primary;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isNext
                ? color.withOpacity(0.12)
                : Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(14),
            border: isNext
                ? Border.all(color: color.withOpacity(0.4), width: 1.5)
                : Border.all(color: AppColors.divider),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            trailing: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Icon(_prayerIcon(entry.key), color: color, size: 22),
            ),
            title: Text(
              ArabicUtils.prayerName(entry.key),
              style: AppTypography.heading3.copyWith(
                color: isNext ? color : AppColors.textPrimary,
              ),
              textDirection: TextDirection.rtl,
            ),
            leading: Text(
              ArabicUtils.toArabicTime(entry.value),
              style: TextStyle(
                fontFamily: 'NotoNaskhArabic',
                fontSize: 18,
                fontWeight:
                    isNext ? FontWeight.w700 : FontWeight.normal,
                color:
                    isNext ? color : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationInfo(PrayerTimesData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on_outlined,
            size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(data.locationName, style: AppTypography.caption),
      ],
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'يتطلب هذا الإذن الوصول إلى موقعك لحساب أوقات الصلاة',
              style: AppTypography.body,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.invalidate(prayerTimesProvider),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _prayerIcon(String key) {
    switch (key) {
      case 'fajr':    return Icons.wb_twilight;
      case 'dhuhr':   return Icons.wb_sunny;
      case 'asr':     return Icons.wb_cloudy;
      case 'maghrib': return Icons.wb_twilight;
      case 'isha':    return Icons.nightlight;
      default:        return Icons.access_time;
    }
  }

  void _showCalculationMethodSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('طريقة حساب أوقات الصلاة',
                  style: AppTypography.heading3),
              const SizedBox(height: 16),
              ...AppConstants.calculationMethods.map((m) => ListTile(
                    title: Text(m['name'] as String,
                        style: AppTypography.body,
                        textDirection: TextDirection.rtl),
                    onTap: () => Navigator.pop(context),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
