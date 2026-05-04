import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../../services/notification_service.dart';
import '../providers/prayer_times_provider.dart';
import '../providers/adhan_settings_provider.dart';

class PrayerTimesScreen extends ConsumerStatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  ConsumerState<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends ConsumerState<PrayerTimesScreen> {
  Timer? _timer;
  Duration _countdown = Duration.zero;
  String? _lastPrayerKey;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _countdown.inSeconds > 0) {
        setState(() => _countdown -= const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prayerAsync = ref.watch(prayerTimesProvider);
    final settingsAsync = ref.watch(adhanSettingsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: const Text(
            'أوقات الصلاة',
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.explore_outlined, color: Colors.white),
              onPressed: () => context.push('/qibla'),
              tooltip: 'اتجاه القبلة',
            ),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () => _showAdhanSettings(context, settingsAsync.valueOrNull),
              tooltip: 'إعدادات الأذان',
            ),
          ],
        ),
        body: prayerAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (e, _) => _buildError(context, e.toString()),
          data: (data) {
            // Reset countdown when the next prayer changes or on first load
            if (_lastPrayerKey != data.nextPrayerName) {
              _lastPrayerKey = data.nextPrayerName;
              _countdown = data.timeUntilNext;
            } else if (_countdown == Duration.zero) {
              _countdown = data.timeUntilNext;
            }
            return _buildBody(data, settingsAsync.valueOrNull);
          },
        ),
      ),
    );
  }

  Widget _buildBody(PrayerTimesData data, AdhanSettings? settings) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildNextPrayerHero(data),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              children: [
                _buildPrayersList(data, settings),
                const SizedBox(height: 16),
                if (settings != null) _buildAdhanBanner(context, settings),
                const SizedBox(height: 12),
                _buildLocationInfo(data),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextPrayerHero(PrayerTimesData data) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'الصلاة القادمة',
                  style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                ArabicUtils.prayerName(data.nextPrayerName),
                style: const TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                ArabicUtils.formatPrayerCountdown(_countdown),
                style: AppTypography.prayerTime.copyWith(
                  color: AppColors.gold,
                  fontSize: 48,
                  letterSpacing: 2,
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
        ),
      ),
    );
  }

  Widget _buildPrayersList(PrayerTimesData data, AdhanSettings? settings) {
    return Column(
      children: data.todayPrayers.entries.map((entry) {
        return _buildPrayerTile(
          prayerKey: entry.key,
          timeStr: entry.value,
          isNext: entry.key == data.nextPrayerName,
          adhanEnabled: settings?.isPrayerEnabled(entry.key) ?? true,
          onAdhanTap: () => _showAdhanSettings(context, settings),
        );
      }).toList(),
    );
  }

  Widget _buildPrayerTile({
    required String prayerKey,
    required String timeStr,
    required bool isNext,
    required bool adhanEnabled,
    required VoidCallback onAdhanTap,
  }) {
    final color = _prayerColor(prayerKey);
    final icon = _prayerIcon(prayerKey);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isNext ? color.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNext ? color.withOpacity(0.4) : AppColors.divider,
          width: isNext ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Time
            Text(
              timeStr,
              style: TextStyle(
                fontFamily: 'NotoNaskhArabic',
                fontSize: 17,
                fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
                color: isNext ? color : AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            // Prayer name + subtitle
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  ArabicUtils.prayerName(prayerKey),
                  style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: isNext ? color : AppColors.textPrimary,
                  ),
                ),
                if (isNext)
                  Text(
                    'الصلاة القادمة',
                    style: TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 11,
                      color: color.withOpacity(0.8),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 8),
            // Adhan bell toggle
            GestureDetector(
              onTap: onAdhanTap,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: adhanEnabled
                      ? AppColors.gold.withOpacity(0.12)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  adhanEnabled ? Icons.notifications_active : Icons.notifications_off_outlined,
                  color: adhanEnabled ? AppColors.gold : Colors.grey,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdhanBanner(BuildContext context, AdhanSettings settings) {
    return GestureDetector(
      onTap: () => _showAdhanSettings(context, settings),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.chevron_left, color: Colors.white60, size: 20),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  settings.voice.label,
                  style: const TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${settings.voice.muezzin} · ${settings.enabledCount} صلوات مفعّلة',
                  style: const TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.spatial_audio, color: AppColors.gold, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo(PrayerTimesData data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
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
            const Icon(Icons.location_off, size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            const Text(
              'يتطلب التطبيق الوصول إلى موقعك لحساب أوقات الصلاة',
              style: AppTypography.body,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(prayerTimesProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdhanSettings(BuildContext context, AdhanSettings? settings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AdhanSettingsSheet(currentSettings: settings),
    );
  }

  Color _prayerColor(String key) {
    switch (key) {
      case 'fajr':    return AppColors.fajr;
      case 'dhuhr':   return AppColors.dhuhr;
      case 'asr':     return AppColors.asr;
      case 'maghrib': return AppColors.maghrib;
      case 'isha':    return AppColors.isha;
      default:        return AppColors.primary;
    }
  }

  IconData _prayerIcon(String key) {
    switch (key) {
      case 'fajr':    return Icons.wb_twilight;
      case 'dhuhr':   return Icons.wb_sunny;
      case 'asr':     return Icons.wb_cloudy_outlined;
      case 'maghrib': return Icons.nights_stay_outlined;
      case 'isha':    return Icons.nightlight_round;
      default:        return Icons.access_time;
    }
  }
}

// ─── Adhan Settings Bottom Sheet ────────────────────────────────────────────

class _AdhanSettingsSheet extends ConsumerStatefulWidget {
  final AdhanSettings? currentSettings;
  const _AdhanSettingsSheet({this.currentSettings});

  @override
  ConsumerState<_AdhanSettingsSheet> createState() =>
      _AdhanSettingsSheetState();
}

class _AdhanSettingsSheetState extends ConsumerState<_AdhanSettingsSheet> {
  static const _prayers = [
    ('fajr', 'صلاة الفجر', Icons.wb_twilight, AppColors.fajr),
    ('dhuhr', 'صلاة الظهر', Icons.wb_sunny, AppColors.dhuhr),
    ('asr', 'صلاة العصر', Icons.wb_cloudy_outlined, AppColors.asr),
    ('maghrib', 'صلاة المغرب', Icons.nights_stay_outlined, AppColors.maghrib),
    ('isha', 'صلاة العشاء', Icons.nightlight_round, AppColors.isha),
  ];

  AudioPlayer? _player;
  AdhanVoice? _playingVoice;

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  Future<void> _togglePreview(AdhanVoice voice) async {
    if (_playingVoice == voice) {
      await _player?.stop();
      if (mounted) setState(() => _playingVoice = null);
      return;
    }
    await _player?.stop();
    _player ??= AudioPlayer();
    if (mounted) setState(() => _playingVoice = voice);
    try {
      final file = voice == AdhanVoice.madani
          ? 'assets/audio/adhan_madani.wav'
          : 'assets/audio/adhan_makki.wav';
      await _player!.setAudioSource(AudioSource.asset(file));
      await _player!.play();
      _player!.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          if (mounted) setState(() => _playingVoice = null);
        }
      });
    } catch (_) {
      if (mounted) setState(() => _playingVoice = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(adhanSettingsProvider);
    final notifier = ref.read(adhanSettingsProvider.notifier);
    final settings = settingsAsync.valueOrNull ?? AdhanSettings.defaults;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.spatial_audio,
                        color: AppColors.gold, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إعدادات الأذان',
                        style: TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'اختر الصوت وحدّد الصلوات',
                        style: TextStyle(
                          fontFamily: 'NotoNaskhArabic',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 24, indent: 20, endIndent: 20),
            // Voice selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'صوت الأذان',
                    style: TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: AdhanVoice.values.map((voice) {
                      final selected = settings.voice == voice;
                      final isPlaying = _playingVoice == voice;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => notifier.setVoice(voice),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.fromLTRB(10, 10, 12, 10),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.divider,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Play preview button
                                    GestureDetector(
                                      onTap: () => _togglePreview(voice),
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: isPlaying
                                              ? AppColors.gold
                                              : (selected
                                                  ? Colors.white
                                                      .withOpacity(0.15)
                                                  : AppColors.primary
                                                      .withOpacity(0.1)),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isPlaying
                                              ? Icons.stop_rounded
                                              : Icons.play_arrow_rounded,
                                          size: 16,
                                          color: isPlaying
                                              ? Colors.white
                                              : (selected
                                                  ? AppColors.gold
                                                  : AppColors.primary),
                                        ),
                                      ),
                                    ),
                                    // Label + icon
                                    Row(
                                      children: [
                                        Text(
                                          voice.label,
                                          style: TextStyle(
                                            fontFamily: 'NotoNaskhArabic',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: selected
                                                ? Colors.white
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          Icons.record_voice_over,
                                          size: 16,
                                          color: selected
                                              ? AppColors.gold
                                              : AppColors.textSecondary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  voice.muezzin,
                                  style: TextStyle(
                                    fontFamily: 'NotoNaskhArabic',
                                    fontSize: 11,
                                    color: selected
                                        ? Colors.white70
                                        : AppColors.textSecondary,
                                  ),
                                ),
                                if (isPlaying) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    '▶ جاري التشغيل...',
                                    style: TextStyle(
                                      fontFamily: 'NotoNaskhArabic',
                                      fontSize: 10,
                                      color: selected
                                          ? AppColors.gold
                                          : AppColors.primary,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, indent: 20, endIndent: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  const Spacer(),
                  const Text(
                    'الصلوات المفعّلة',
                    style: TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ..._prayers.map(
              (p) => _buildPrayerToggle(
                prayerKey: p.$1,
                label: p.$2,
                icon: p.$3,
                color: p.$4,
                enabled: settings.isPrayerEnabled(p.$1),
                onToggle: () => notifier.togglePrayer(p.$1),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  20, 16, 20, MediaQuery.of(context).padding.bottom + 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await _player?.stop();
                    final prayerAsync =
                        ref.read(prayerTimesProvider).valueOrNull;
                    if (prayerAsync != null) {
                      final rawTimes = {
                        'fajr': prayerAsync.prayerTimes.fajr,
                        'dhuhr': prayerAsync.prayerTimes.dhuhr,
                        'asr': prayerAsync.prayerTimes.asr,
                        'maghrib': prayerAsync.prayerTimes.maghrib,
                        'isha': prayerAsync.prayerTimes.isha,
                      };
                      await NotificationService.instance
                          .schedulePrayerNotifications(
                        prayerTimes: rawTimes,
                        settings: settings,
                      );
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'حفظ وجدولة التنبيهات',
                    style: TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerToggle({
    required String prayerKey,
    required String label,
    required IconData icon,
    required Color color,
    required bool enabled,
    required VoidCallback onToggle,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      leading: Switch(
        value: enabled,
        onChanged: (_) => onToggle(),
        activeColor: AppColors.primary,
        activeTrackColor: AppColors.primaryLight.withOpacity(0.4),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'NotoNaskhArabic',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
        ),
        textDirection: TextDirection.rtl,
      ),
      trailing: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: enabled
              ? color.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: enabled ? color : Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
