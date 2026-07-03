/**
 * Push notification service using expo-notifications + Firebase Cloud Messaging.
 *
 * Setup required:
 *  1. Android: add google-services.json to project root
 *  2. iOS: add GoogleService-Info.plist + enable Push Notifications capability
 *  3. In app.json add:
 *       "plugins": ["expo-notifications"]
 *       "android": { "googleServicesFile": "./google-services.json" }
 *       "ios": { "googleServicesFile": "./GoogleService-Info.plist" }
 *
 * This service:
 *  - Requests notification permission on first launch
 *  - Gets the FCM token and saves it to Firestore
 *  - Schedules local prayer time notifications
 */

import * as Notifications from 'expo-notifications';
import { Platform }        from 'react-native';
import { doc, updateDoc }  from 'firebase/firestore';
import { db }              from '../config/firebase';

// Show notifications when the app is in foreground
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge:  false,
  }),
});

// ── Permission + FCM token ────────────────────────────────────────────────────

export async function registerForPushNotifications(uid) {
  if (Platform.OS === 'android') {
    await Notifications.setNotificationChannelAsync('prayer-times', {
      name:       'أوقات الصلاة',
      importance: Notifications.AndroidImportance.HIGH,
      sound:      'default',
      vibrationPattern: [0, 250, 250, 250],
    });
  }

  const { status: existing } = await Notifications.getPermissionsAsync();
  let finalStatus = existing;

  if (existing !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync();
    finalStatus = status;
  }

  if (finalStatus !== 'granted') return null;

  try {
    const { data: token } = await Notifications.getExpoPushTokenAsync();

    // Save token to Firestore so server can send targeted pushes
    if (uid) {
      await updateDoc(doc(db, 'users', uid), { expoPushToken: token });
    }

    return token;
  } catch (_) {
    return null;
  }
}

// ── Prayer time notifications ─────────────────────────────────────────────────

const PRAYER_NAMES = {
  fajr:    'الفجر',
  dhuhr:   'الظهر',
  asr:     'العصر',
  maghrib: 'المغرب',
  isha:    'العشاء',
};

/**
 * Schedule daily prayer notifications.
 * prayerTimes: { fajr: Date, dhuhr: Date, asr: Date, maghrib: Date, isha: Date }
 * enabledPrayers: { fajr: bool, dhuhr: bool, ... }
 */
export async function schedulePrayerNotifications(prayerTimes, enabledPrayers = {}) {
  // Cancel all existing prayer notifications first
  await Notifications.cancelAllScheduledNotificationsAsync();

  for (const [key, name] of Object.entries(PRAYER_NAMES)) {
    if (!enabledPrayers[key]) continue;
    const time = prayerTimes[key];
    if (!time || time < new Date()) continue;

    await Notifications.scheduleNotificationAsync({
      content: {
        title: `حان وقت صلاة ${name} 🕌`,
        body:  'حيَّ على الصلاة، حيَّ على الفلاح',
        sound: 'default',
        data:  { prayer: key },
      },
      trigger: {
        date:    time,
        repeats: false,
      },
    });
  }
}

export async function cancelAllNotifications() {
  await Notifications.cancelAllScheduledNotificationsAsync();
}
