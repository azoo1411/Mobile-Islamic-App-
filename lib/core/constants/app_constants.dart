class AppConstants {
  AppConstants._();

  static const int totalSurahs = 114;
  static const int totalAyahs = 6236;

  // Mushaf page image CDNs — tried in order until one succeeds
  static const List<String> mushafCdnUrls = [
    'https://static.qurancdn.com/images/mushaf/hafs/compressed',  // {page}.jpg  (no padding)
    'https://www.searchtruth.com/quran/images2/large',             // page-{001}.jpg (padded)
  ];
  // keep for legacy references
  static String get mushafImageBaseUrl => mushafCdnUrls.first;

  // Primary audio CDN — verses.quran.com (Minshawi default)
  static const String audioBaseUrl = 'https://verses.quran.com';

  // Default reciter
  static const String defaultReciter = 'minshawi';

  static const List<Map<String, String>> reciters = [
    {'id': 'minshawi',  'name': 'محمد صديق المنشاوي', 'path': 'AlMinshawi/mp3'},
    {'id': 'alafasy',   'name': 'مشاري راشد العفاسي',  'path': 'Alafasy/mp3'},
    {'id': 'husary',    'name': 'محمود خليل الحصري',    'path': 'Husary/mp3'},
    {'id': 'sudais',    'name': 'عبد الرحمن السديس',    'path': 'Abdurrahmaan_As-Sudais/mp3'},
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
  static const String prefLastMushafPage = 'last_mushaf_page';
  static const String prefOnboardingDone = 'onboarding_done';
  static const String prefLastLat = 'last_lat';
  static const String prefLastLon = 'last_lon';
}
