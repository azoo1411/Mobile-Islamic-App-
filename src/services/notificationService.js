/**
 * إشعارات أوقات الصلاة — expo-notifications + Firebase Cloud Messaging
 *
 * الإعداد المطلوب (مرة واحدة):
 *  Android: ضع google-services.json في مجلد المشروع
 *  iOS:     ضع GoogleService-Info.plist + فعّل Push Notifications
 *  app.json: تأكد من وجود plugin: ["expo-notifications"]
 */

import * as Notifications from 'expo-notifications';
import { Platform }        from 'react-native';
import Constants           from 'expo-constants';
import { doc, updateDoc }  from 'firebase/firestore';
import { db }              from '../config/firebase';

// الإشعارات تظهر حتى عندما التطبيق مفتوح
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowBanner: true,
    shouldPlaySound: true,
    shouldSetBadge:  false,
  }),
});

// ── تسجيل الجهاز ─────────────────────────────────────────────────────────────

export async function registerForPushNotifications(uid) {
  if (Platform.OS === 'android') {
    await Notifications.setNotificationChannelAsync('prayer-times', {
      name:             'أوقات الصلاة',
      importance:       Notifications.AndroidImportance.HIGH,
      sound:            'default',
      vibrationPattern: [0, 250, 250, 250],
    });
  }

  const { status } = await Notifications.requestPermissionsAsync();
  if (status !== 'granted') return null;

  try {
    const { data: token } = await Notifications.getExpoPushTokenAsync({
      projectId: Constants.expoConfig?.extra?.eas?.projectId,
    });
    // احفظ توكن الجهاز في Firestore لإمكانية إرسال إشعارات مستقبلاً
    if (uid) {
      await updateDoc(doc(db, 'userPrefs', uid), { expoPushToken: token });
    }
    return token;
  } catch (_) { return null; }
}

// ── جدولة إشعارات الصلاة ─────────────────────────────────────────────────────

const PRAYER_LABELS = {
  fajr:    'الفجر',
  dhuhr:   'الظهر',
  asr:     'العصر',
  maghrib: 'المغرب',
  isha:    'العشاء',
};

/**
 * @param prayerTimes  { fajr: Date, dhuhr: Date, asr: Date, maghrib: Date, isha: Date }
 * @param alerts       { fajr: bool, dhuhr: bool, asr: bool, maghrib: bool, isha: bool }
 */
export async function schedulePrayerNotifications(prayerTimes, alerts = {}) {
  await Notifications.cancelAllScheduledNotificationsAsync();

  const now = new Date();
  for (const [key, label] of Object.entries(PRAYER_LABELS)) {
    if (!alerts[key]) continue;
    const time = prayerTimes[key];
    if (!time || time <= now) continue;

    await Notifications.scheduleNotificationAsync({
      content: {
        title: `حان وقت صلاة ${label} 🕌`,
        body:  'حيَّ على الصلاة · حيَّ على الفلاح',
        sound: 'default',
        data:  { prayer: key },
      },
      trigger: { date: time, repeats: false },
    });
  }
}

export async function cancelAllNotifications() {
  await Notifications.cancelAllScheduledNotificationsAsync();
}
