class AppConstants {
  AppConstants._();

  static const int totalSurahs = 114;
  static const int totalAyahs = 6236;

  // Audio base URL — everyayah.com provides free Quran audio
  static const String audioBaseUrl = 'https://everyayah.com/data';

  // Default reciter (Hafs from Aasim — most common)
  static const String defaultReciter = 'Alafasy_128kbps';

  static const List<Map<String, String>> reciters = [
    {'id': 'Alafasy_128kbps', 'name': 'مشاري راشد العفاسي'},
    {'id': 'Husary_128kbps', 'name': 'محمود خليل الحصري'},
    {'id': 'Minshawi_128kbps', 'name': 'محمد صديق المنشاوي'},
    {'id': 'Abu_Bakr_Ash-Shaatree_128kbps', 'name': 'أبو بكر الشاطري'},
    {'id': 'AbdurRahmaanAs-Sudais_192kbps', 'name': 'عبد الرحمن السديس'},
    {'id': 'Ahmed_ibn_Ali_al-Ajamy_128kbps_ketabook', 'name': 'أحمد العجمي'},
  ];

  static const List<Map<String, String>> hadithBooks = [
    {'id': 'bukhari', 'name': 'صحيح البخاري', 'total': '7563'},
    {'id': 'muslim', 'name': 'صحيح مسلم', 'total': '3033'},
    {'id': 'abudawud', 'name': 'سنن أبي داود', 'total': '5274'},
    {'id': 'tirmidhi', 'name': 'جامع الترمذي', 'total': '3956'},
  ];

  static const List<Map<String, String>> poetryCategories = [
    {'id': 'madh', 'name': 'مدح الرسول ﷺ', 'icon': '🌟'},
    {'id': 'andalus', 'name': 'أندلسيات', 'icon': '🏰'},
    {'id': 'hikam', 'name': 'حكم وأمثال', 'icon': '📖'},
    {'id': 'sabr', 'name': 'صبر وتوكل', 'icon': '🌿'},
    {'id': 'ibtihaal', 'name': 'ابتهالات', 'icon': '🤲'},
  ];

  // Prayer calculation methods
  static const List<Map<String, dynamic>> calculationMethods = [
    {'id': 0, 'name': 'رابطة العالم الإسلامي'},
    {'id': 1, 'name': 'الهيئة الإسلامية لأمريكا الشمالية'},
    {'id': 2, 'name': 'اتحاد المنظمات الإسلامية في أوروبا'},
    {'id': 3, 'name': 'جامعة العلوم الإسلامية، كراتشي'},
    {'id': 4, 'name': 'مصلحة الإفتاء، مصر'},
    {'id': 5, 'name': 'أم القرى، مكة المكرمة'},
  ];

  // SharedPreferences keys
  static const String prefThemeMode = 'theme_mode';
  static const String prefFontSize = 'font_size';
  static const String prefReciter = 'reciter';
  static const String prefCalcMethod = 'calc_method';
  static const String prefNotificationsEnabled = 'notifications';
  static const String prefLastReadSurah = 'last_read_surah';
  static const String prefLastReadAyah = 'last_read_ayah';
  static const String prefOnboardingDone = 'onboarding_done';
  static const String prefLastLat = 'last_lat';
  static const String prefLastLon = 'last_lon';
}
