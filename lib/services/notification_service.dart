import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId   = 'prayer_times';
  static const _channelName = 'أوقات الصلاة';
  static const _channelDesc = 'إشعارات مواعيد الصلاة والأذان';

  // Arabic prayer names used in notification titles
  static const _prayerNames = {
    'fajr':    'الفجر',
    'dhuhr':   'الظهر',
    'asr':     'العصر',
    'maghrib': 'المغرب',
    'isha':    'العشاء',
  };

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

    // High-priority channel with adhan sound.
    // Place adhan.mp3 in android/app/src/main/res/raw/ for custom sound;
    // falls back to the default alarm tone if the file is absent.
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('adhan'),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Schedule one notification per prayer.
  /// [prayerTimes] maps prayer keys (fajr, dhuhr …) to their DateTime.
  Future<void> schedulePrayerNotifications({
    required Map<String, DateTime> prayerTimes,
  }) async {
    // Cancel any previously scheduled prayer notifications (ids 0-4)
    for (int i = 0; i < 5; i++) {
      await _plugin.cancel(i);
    }

    final now = tz.TZDateTime.now(tz.local);
    int id = 0;

    for (final entry in prayerTimes.entries) {
      final name  = _prayerNames[entry.key] ?? entry.key;
      final tzTime = tz.TZDateTime.from(entry.value, tz.local);

      if (tzTime.isAfter(now)) {
        await _plugin.zonedSchedule(
          id,
          'حان وقت صلاة $name',
          'الله أكبر الله أكبر، أشهد أن لا إله إلا الله',
          tzTime,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              _channelName,
              channelDescription: _channelDesc,
              importance: Importance.max,
              priority: Priority.max,
              sound: const RawResourceAndroidNotificationSound('adhan'),
              playSound: true,
              enableVibration: true,
              styleInformation: const BigTextStyleInformation(
                'الله أكبر الله أكبر، أشهد أن لا إله إلا الله، '
                'أشهد أن محمداً رسول الله، حي على الصلاة، حي على الفلاح',
              ),
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              sound: 'adhan.aiff',
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
      id++;
    }
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
