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
  final Map<String, DateTime> rawTimes;

  PrayerTimesData({
    required this.locationName,
    required this.nextPrayerName,
    required this.timeUntilNext,
    required this.todayPrayers,
    required this.prayerTimes,
    required this.rawTimes,
  });
}

final prayerTimesProvider = FutureProvider<PrayerTimesData>((ref) async {
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
  final methodIndex = prefs.getInt(AppConstants.prefCalcMethod) ?? 0;

  final coordinates = Coordinates(position.latitude, position.longitude);
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

  final nextPrayerEnum = prayerTimes.nextPrayer();
  final now = DateTime.now();
  final String nextName;
  final DateTime? nextPrayerTime;

  if (nextPrayerEnum == Prayer.none) {
    // After Isha — next prayer is tomorrow's Fajr
    final tomorrow = DateComponents.from(now.add(const Duration(days: 1)));
    final tomorrowTimes = PrayerTimes(coordinates, tomorrow, params);
    nextPrayerTime = tomorrowTimes.fajr;
    nextName = 'fajr';
  } else {
    nextPrayerTime = prayerTimes.timeForPrayer(nextPrayerEnum);
    nextName = _prayerEnumToKey(nextPrayerEnum);
  }

  final timeUntil = nextPrayerTime?.difference(now) ?? Duration.zero;

  final rawTimes = {
    'fajr': prayerTimes.fajr,
    'dhuhr': prayerTimes.dhuhr,
    'asr': prayerTimes.asr,
    'maghrib': prayerTimes.maghrib,
    'isha': prayerTimes.isha,
  };

  return PrayerTimesData(
    locationName:
        '${position.latitude.toStringAsFixed(2)}° , ${position.longitude.toStringAsFixed(2)}°',
    nextPrayerName: nextName,
    timeUntilNext: timeUntil.isNegative ? Duration.zero : timeUntil,
    todayPrayers: prayers,
    prayerTimes: prayerTimes,
    rawTimes: rawTimes,
  );
});

CalculationParameters _getCalculationParams(int methodIndex) {
  switch (methodIndex) {
    case 0:
      return CalculationMethod.muslim_world_league.getParameters();
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
