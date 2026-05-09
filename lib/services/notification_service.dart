import 'package:adhan/adhan.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../core/constants/app_constants.dart';
import '../core/utils/arabic_utils.dart';
import '../features/prayer_times/presentation/providers/adhan_settings_provider.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelIdMadani = 'adhan_madani_v2';
  static const _channelIdMakki = 'adhan_makki_v2';
  static const _channelIdSilent = 'prayer_silent_v2';

  // IDs 0–69 reserved for 7-day prayer schedule (7 days × 5 prayers × 2 slots)
  static const int _scheduleSlots = 70;

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    await _createChannel(id: _channelIdMadani, name: 'أذان مدني — عصام بخاري', sound: 'adhan_madani');
    await _createChannel(id: _channelIdMakki, name: 'أذان مكي — هاشم السقاف', sound: 'adhan_makki');

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelIdSilent,
            'تنبيهات الصلاة',
            description: 'تنبيه بدون صوت أذان',
            importance: Importance.high,
            enableVibration: true,
            playSound: false,
          ),
        );
  }

  Future<void> _createChannel({
    required String id,
    required String name,
    required String sound,
  }) async {
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          AndroidNotificationChannel(
            id,
            name,
            description: 'يُشغّل صوت الأذان عند وقت الصلاة',
            importance: Importance.max,
            enableVibration: true,
            playSound: true,
            sound: RawResourceAndroidNotificationSound(sound),
          ),
        );
  }

  /// Schedule 7 days of prayer notifications (35 total).
  /// Call this whenever the app starts or settings change.
  Future<void> scheduleWeeklyAdhan({
    required double lat,
    required double lon,
    required int methodIndex,
    required AdhanSettings settings,
  }) async {
    // Cancel all existing prayer schedule slots
    for (int i = 0; i < _scheduleSlots; i++) {
      await _plugin.cancel(i);
    }

    final coordinates = Coordinates(lat, lon);
    final params = _calcParams(methodIndex);
    final now = DateTime.now();
    final prayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

    int notifId = 0;
    for (int day = 0; day < 7; day++) {
      final date = now.add(Duration(days: day));
      final components = DateComponents.from(date);
      final times = PrayerTimes(coordinates, components, params);

      final dayTimes = {
        'fajr': times.fajr,
        'dhuhr': times.dhuhr,
        'asr': times.asr,
        'maghrib': times.maghrib,
        'isha': times.isha,
      };

      for (final prayerKey in prayers) {
        final time = dayTimes[prayerKey]!;
        if (!time.isAfter(now)) {
          notifId++;
          continue;
        }

        final adhanEnabled = settings.isPrayerEnabled(prayerKey);
        final prayerName = ArabicUtils.prayerName(prayerKey);
        final channelId = adhanEnabled
            ? (settings.voice == AdhanVoice.makki ? _channelIdMakki : _channelIdMadani)
            : _channelIdSilent;
        final soundRaw = adhanEnabled
            ? RawResourceAndroidNotificationSound(
                settings.voice == AdhanVoice.makki ? 'adhan_makki' : 'adhan_madani',
              )
            : null;

        await _plugin.zonedSchedule(
          notifId++,
          'حان وقت $prayerName',
          adhanEnabled
              ? 'اللهُ أَكْبَر، اللهُ أَكْبَر — ${settings.voice.muezzin}'
              : 'حان وقت صلاة $prayerName',
          tz.TZDateTime.from(time, tz.local),
          NotificationDetails(
            android: AndroidNotificationDetails(
              channelId,
              adhanEnabled ? settings.voice.label : 'تنبيه صامت',
              channelDescription: 'إشعار وقت الصلاة',
              importance: Importance.max,
              priority: Priority.high,
              sound: soundRaw,
              playSound: adhanEnabled,
              enableVibration: true,
              styleInformation: BigTextStyleInformation(
                'اللهُ أَكْبَر، اللهُ أَكْبَر، أَشْهَدُ أَن لَا إِلَهَ إِلَّا الله',
              ),
              largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: adhanEnabled,
            ),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
  }

  /// Schedule using last-known saved coordinates (called at app startup).
  Future<void> scheduleFromSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble(AppConstants.prefLastLat);
    final lon = prefs.getDouble(AppConstants.prefLastLon);
    if (lat == null || lon == null) return;

    final methodIndex = prefs.getInt(AppConstants.prefCalcMethod) ?? 0;

    final voiceKey = prefs.getString('adhan_voice') ?? AdhanVoice.madani.key;
    final voice = AdhanVoice.values.firstWhere(
      (v) => v.key == voiceKey,
      orElse: () => AdhanVoice.madani,
    );
    const prayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
    final enabled = {
      for (final p in prayers) p: prefs.getBool('adhan_$p') ?? true,
    };
    final settings = AdhanSettings(voice: voice, enabledPrayers: enabled);

    await scheduleWeeklyAdhan(
      lat: lat,
      lon: lon,
      methodIndex: methodIndex,
      settings: settings,
    );
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      999,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelIdSilent,
          'تنبيهات',
          importance: Importance.defaultImportance,
        ),
      ),
    );
  }

  /// Returns true if the device can schedule exact alarms.
  /// On Android 12+ this requires SCHEDULE_EXACT_ALARM to be granted.
  Future<bool> canScheduleExact() async {
    final plugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (plugin == null) return true;
    return await plugin.canScheduleExactNotifications() ?? true;
  }

  /// Opens the system "Alarms & reminders" settings page so the user
  /// can grant SCHEDULE_EXACT_ALARM.
  Future<void> requestExactAlarmPermission() async {
    final plugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await plugin?.requestExactAlarmsPermission();
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}

CalculationParameters _calcParams(int methodIndex) {
  switch (methodIndex) {
    case 1:
      return CalculationMethod.north_america.getParameters();
    case 2:
      return CalculationMethod.moon_sighting_committee.getParameters();
    case 3:
      return CalculationMethod.karachi.getParameters();
    case 4:
      return CalculationMethod.egyptian.getParameters();
    case 5:
      return CalculationMethod.umm_al_qura.getParameters();
    default:
      return CalculationMethod.muslim_world_league.getParameters();
  }
}
