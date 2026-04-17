import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../core/utils/arabic_utils.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'prayer_times';
  static const _channelName = 'أوقات الصلاة';
  static const _channelDesc = 'إشعارات مواعيد الصلاة والأذان';

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

    // Create notification channel for Android
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> schedulePrayerNotifications({
    required Map<String, DateTime> prayerTimes,
  }) async {
    // Cancel existing prayer notifications first
    for (int i = 0; i < 5; i++) {
      await _plugin.cancel(i);
    }

    int id = 0;
    for (final entry in prayerTimes.entries) {
      final prayerName = ArabicUtils.prayerName(entry.key);
      final time = entry.value;

      if (time.isAfter(DateTime.now())) {
        await _plugin.zonedSchedule(
          id++,
          'حان وقت $prayerName',
          'الله أكبر، الله أكبر، أشهد أن لا إله إلا الله...',
          tz.TZDateTime.from(time, tz.local),
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channelId,
              _channelName,
              channelDescription: _channelDesc,
              importance: Importance.high,
              priority: Priority.high,
              styleInformation: const BigTextStyleInformation(''),
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
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
          _channelId,
          _channelName,
          importance: Importance.defaultImportance,
        ),
      ),
    );
  }

  Future<void> cancelAll() => _plugin.cancelAll();
}
