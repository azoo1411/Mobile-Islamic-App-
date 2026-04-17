class ArabicUtils {
  ArabicUtils._();

  static String toArabicNumerals(int number) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = number.toString();
    for (int i = 0; i < western.length; i++) {
      result = result.replaceAll(western[i], arabic[i]);
    }
    return result;
  }

  static String toArabicTime(String time) {
    return time
        .replaceAll('0', '٠')
        .replaceAll('1', '١')
        .replaceAll('2', '٢')
        .replaceAll('3', '٣')
        .replaceAll('4', '٤')
        .replaceAll('5', '٥')
        .replaceAll('6', '٦')
        .replaceAll('7', '٧')
        .replaceAll('8', '٨')
        .replaceAll('9', '٩');
  }

  // Encapsulate ayah number in Quran-style circle character
  static String ayahNumber(int number) => '﴿${toArabicNumerals(number)}﴾';

  static String formatPrayerCountdown(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '${toArabicNumerals(hours)}:${toArabicNumerals(minutes).padLeft(2, '٠')}:${toArabicNumerals(seconds).padLeft(2, '٠')}';
    }
    return '${toArabicNumerals(minutes)}:${toArabicNumerals(seconds).padLeft(2, '٠')}';
  }

  static String prayerName(String key) {
    const names = {
      'fajr': 'الفجر',
      'sunrise': 'الشروق',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
    };
    return names[key] ?? key;
  }

  static String hijriMonthName(int month) {
    const months = [
      'محرم', 'صفر', 'ربيع الأول', 'ربيع الثاني',
      'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان',
      'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة',
    ];
    return months[month - 1];
  }

  static String dayOfWeek(int weekday) {
    const days = {
      1: 'الاثنين', 2: 'الثلاثاء', 3: 'الأربعاء',
      4: 'الخميس', 5: 'الجمعة', 6: 'السبت', 7: 'الأحد',
    };
    return days[weekday] ?? '';
  }
}
