import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../core/utils/arabic_utils.dart';
import '../features/prayer_times/presentation/providers/adhan_settings_provider.dart';

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelIdMadani = 'adhan_madani';
  static const _channelIdMakki = 'adhan_makki';
  static const _channelIdSilent = 'prayer_silent';

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

    // Madani adhan channel
    await _createChannel(
      id: _channelIdMadani,
      name: 'أذان مدني — عبدالرحمن خاشقجي',
      sound: 'adhan_madani',
    );

    // Makki adhan channel
    await _createChannel(
      id: _channelIdMakki,
      name: 'أذان مكي — هاشم السقاف',
      sound: 'adhan_makki',
    );

    // Silent notification channel (for disabled adhan)
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
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
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
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

  Future<void> schedulePrayerNotifications({
    required Map<String, DateTime> prayerTimes,
    required AdhanSettings settings,
  }) async {
    // Cancel existing prayer notifications
    for (int i = 0; i < 10; i++) {
      await _plugin.cancel(i);
    }

    int id = 0;
    for (final entry in prayerTimes.entries) {
      final prayerKey = entry.key;
      final prayerName = ArabicUtils.prayerName(prayerKey);
      final time = entry.value;

      if (!time.isAfter(DateTime.now())) {
        id++;
        continue;
      }

      final adhanEnabled = settings.isPrayerEnabled(prayerKey);
      final channelId = adhanEnabled
          ? (settings.voice == AdhanVoice.makki
              ? _channelIdMakki
              : _channelIdMadani)
          : _channelIdSilent;

      final soundRaw = adhanEnabled
          ? RawResourceAndroidNotificationSound(
              settings.voice == AdhanVoice.makki ? 'adhan_makki' : 'adhan_madani',
            )
          : null;

      await _plugin.zonedSchedule(
        id++,
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

  Future<void> cancelAll() => _plugin.cancelAll();
}
