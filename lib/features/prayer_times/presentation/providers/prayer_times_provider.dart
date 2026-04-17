import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';

class PrayerTimesData {
  final String locationName;
  final String nextPrayerName;
  final Duration timeUntilNext;
  final Map<String, String> todayPrayers;
  final PrayerTimes prayerTimes;

  PrayerTimesData({
    required this.locationName,
    required this.nextPrayerName,
    required this.timeUntilNext,
    required this.todayPrayers,
    required this.prayerTimes,
  });
}

final prayerTimesProvider =
    FutureProvider<PrayerTimesData>((ref) async {
  // Check location permission
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw Exception('location_denied');
    }
  }

  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.medium,
  );

  final prefs = await SharedPreferences.getInstance();
  final methodIndex =
      prefs.getInt(AppConstants.prefCalcMethod) ?? 0;

  final coordinates =
      Coordinates(position.latitude, position.longitude);

  final params = _getCalculationParams(methodIndex);
  final today = DateComponents.from(DateTime.now());
  final prayerTimes = PrayerTimes(coordinates, today, params);

  final formatter = DateFormat('hh:mm a');

  final prayers = {
    'fajr': formatter.format(prayerTimes.fajr),
    'dhuhr': formatter.format(prayerTimes.dhuhr),
    'asr': formatter.format(prayerTimes.asr),
    'maghrib': formatter.format(prayerTimes.maghrib),
    'isha': formatter.format(prayerTimes.isha),
  };

  final nextPrayer = prayerTimes.nextPrayer();
  final nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer);
  final now = DateTime.now();
  final timeUntil = nextPrayerTime?.difference(now) ?? Duration.zero;

  final nextName = _prayerEnumToKey(nextPrayer);

  return PrayerTimesData(
    locationName: '${position.latitude.toStringAsFixed(2)}° , ${position.longitude.toStringAsFixed(2)}°',
    nextPrayerName: nextName,
    timeUntilNext: timeUntil,
    todayPrayers: prayers,
    prayerTimes: prayerTimes,
  );
});

CalculationParameters _getCalculationParams(int methodIndex) {
  switch (methodIndex) {
    case 0:
      return CalculationMethod.muslimWorldLeague.getParameters();
    case 1:
      return CalculationMethod.northAmerica.getParameters();
    case 2:
      return CalculationMethod.europe.getParameters();
    case 3:
      return CalculationMethod.karachi.getParameters();
    case 4:
      return CalculationMethod.egyptian.getParameters();
    case 5:
      return CalculationMethod.ummAlQura.getParameters();
    default:
      return CalculationMethod.muslimWorldLeague.getParameters();
  }
}

String _prayerEnumToKey(Prayer prayer) {
  switch (prayer) {
    case Prayer.fajr:
      return 'fajr';
    case Prayer.dhuhr:
      return 'dhuhr';
    case Prayer.asr:
      return 'asr';
    case Prayer.maghrib:
      return 'maghrib';
    case Prayer.isha:
      return 'isha';
    default:
      return 'fajr';
  }
}
