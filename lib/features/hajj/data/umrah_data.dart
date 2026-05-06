import 'package:flutter/material.dart';

class UmrahRitual {
  final String id;
  final String titleArabic;
  final String titleEnglish;
  final String descriptionArabic;
  final List<String> steps;
  final String importantTip;
  final String? dua;
  final String? duaTransliteration;
  final Color primaryColor;
  final Color accentColor;
  final IconData icon;
  final String imagePath;

  const UmrahRitual({
    required this.id,
    required this.titleArabic,
    required this.titleEnglish,
    required this.descriptionArabic,
    required this.steps,
    required this.importantTip,
    this.dua,
    this.duaTransliteration,
    required this.primaryColor,
    required this.accentColor,
    required this.icon,
    required this.imagePath,
  });
}

const List<UmrahRitual> kUmrahRituals = [
  // ─── 1. الإحرام ────────────────────────────────────────────────────────────
  UmrahRitual(
    id: 'umrah_ihram',
    titleArabic: 'الإحرام',
    titleEnglish: 'Ihram',
    descriptionArabic:
        'النية ولبس ملابس الإحرام عند الميقات، وإطلاق التلبية إعلاناً بدء العمرة.',
    steps: [
      'اغتسل وتطيّب قبل الإحرام — لا يجوز التطيب بعد النية',
      'البس ثوبي الإحرام الأبيضين (للرجال) أو الثياب الشرعية الساترة (للنساء)',
      'صلِّ ركعتي سنة الإحرام',
      'انوِ العمرة عند الميقات بقلبك ولسانك: "لبيك اللهم عمرة"',
      'ردّد التلبية بصوت عالٍ حتى تشرع في الطواف',
      'اجتنب محظورات الإحرام: العطر، قص الشعر، الصيد، وغيرها',
    ],
    importantTip:
        'المواقيت تختلف حسب جهة القدوم — تحقق من ميقاتك قبل السفر. أهل مكة يُحرمون من الحِلّ (مثل التنعيم).',
    dua: 'لَبَّيْكَ اللّٰهُمَّ عُمْرَةً',
    duaTransliteration: 'Labbayk Allāhumma ʿumrah',
    primaryColor: Color(0xFF6B5428),
    accentColor: Color(0xFFD4AF37),
    icon: Icons.spa_outlined,
    imagePath: 'assets/images/hajj/ihram.png',
  ),

  // ─── 2. الطواف ──────────────────────────────────────────────────────────────
  UmrahRitual(
    id: 'umrah_tawaf',
    titleArabic: 'طواف العمرة',
    titleEnglish: 'Tawaf al-Umrah',
    descriptionArabic:
        '٧ أشواط حول الكعبة المشرفة عكس عقارب الساعة، يبدأ كل شوط من الحجر الأسود.',
    steps: [
      'توجّه إلى المسجد الحرام وتأكد من الطهارة قبل الطواف',
      'ابدأ من الحجر الأسود — استلمه أو أشر إليه بيدك اليمنى قائلاً "بسم الله الله أكبر"',
      'طُف سبعة أشواط كاملة عكس اتجاه عقارب الساعة (الكعبة على يسارك)',
      'الرجال: يضطبعون (يكشفون الكتف الأيمن) ويرملون في الأشواط الثلاثة الأولى',
      'صلِّ ركعتين خلف مقام إبراهيم بعد انتهاء الطواف',
      'اشرب من ماء زمزم المبارك واتجه إلى الصفا للسعي',
    ],
    importantTip:
        'حاول الطواف في ساعات الفجر أو بعد منتصف الليل لتفادي الزحام. الطهارة شرط لصحة الطواف.',
    dua:
        'بِسْمِ اللهِ وَاللهُ أَكْبَرُ، اللَّهُمَّ إِيمَاناً بِكَ\nوَتَصْدِيقاً بِكِتَابِكَ وَوَفَاءً بِعَهْدِكَ\nوَاتِّبَاعاً لِسُنَّةِ نَبِيِّكَ مُحَمَّدٍ ﷺ',
    duaTransliteration:
        'Bismillāhi wa llāhu akbar — Allāhumma īmānan bika wa taṣdīqan bikitābika\nwa wafāʾan biʿahdika wa ttibāʿan lisunnati nabiyyika Muḥammad ﷺ',
    primaryColor: Color(0xFF1B4A2E),
    accentColor: Color(0xFFD4AF37),
    icon: Icons.rotate_right,
    imagePath: 'assets/images/hajj/tawaf.png',
  ),

  // ─── 3. السعي ───────────────────────────────────────────────────────────────
  UmrahRitual(
    id: 'umrah_sai',
    titleArabic: 'السعي بين الصفا والمروة',
    titleEnglish: "Sa'i",
    descriptionArabic:
        '٧ أشواط بين الصفا والمروة اقتداءً بأم إسماعيل هاجر عليها السلام في بحثها عن الماء.',
    steps: [
      'اتجه إلى جبل الصفا بعد الطواف مباشرة',
      'ارقَ على الصفا واستقبل القبلة، وكبّر ثلاثاً وادعُ الله رافعاً يديك',
      'انزل باتجاه المروة — هذا هو الشوط الأول',
      'الرجال: يسرعون المشي بين العلامتين الخضراوين في كل شوط',
      'ارقَ على المروة وادعُ كما فعلت عند الصفا — هذا نهاية الشوط الأول',
      'أكمل ٧ أشواط — السعي يبدأ بالصفا وينتهي بالمروة',
    ],
    importantTip:
        'الشوط الأول: الصفا → المروة. الشوط الثاني: المروة → الصفا. وهكذا، وآخر شوط ينتهي عند المروة.',
    dua: 'إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ\nأَبْدَأُ بِمَا بَدَأَ اللهُ بِهِ',
    duaTransliteration:
        'Inna ṣ-ṣafā wa l-marwata min shaʿāʾiri llāh\nAbdaʾu bimā badaʾa llāhu bih',
    primaryColor: Color(0xFF6B5010),
    accentColor: Color(0xFFD4AF37),
    icon: Icons.swap_horiz,
    imagePath: 'assets/images/hajj/sai.png',
  ),

  // ─── 4. التحلل ──────────────────────────────────────────────────────────────
  UmrahRitual(
    id: 'umrah_tahallul',
    titleArabic: 'التحلل — الحلق أو التقصير',
    titleEnglish: 'Tahallul',
    descriptionArabic:
        'حلق الرأس أو تقصيره بعد السعي إيذاناً بالخروج من الإحرام وإتمام مناسك العمرة.',
    steps: [
      'يُنفَّذ مباشرة بعد انتهاء السعي عند المروة',
      'الرجال: الأفضل والأكثر ثواباً حلق الرأس كاملاً — والتقصير مجزئ',
      'النساء: يقصّرن قدر أُنملة (أو أكثر) من طرف شعورهن فقط — الحلق محرّم عليهن',
      'بعد الحلق أو التقصير تحللتَ من الإحرام كاملاً',
      'يحل لك الآن: الملابس العادية، العطر، وجميع محظورات الإحرام',
      'اشكر الله على نعمة إتمام عمرتك وأكثر من الدعاء',
    ],
    importantTip:
        'من اعتمر في رمضان فله ثواب حجة مع النبي ﷺ. احرص على إخلاص النية وقبول العمرة.',
    dua: 'اللَّهُمَّ تَقَبَّلْ مِنِّي عُمْرَتِي\nوَاغْفِرْ ذَنْبِي وَأَصْلِحْ عَمَلِي',
    duaTransliteration:
        'Allāhumma taqabbal minnī ʿumratī\nwa ghfir dhanbī wa aṣliḥ ʿamalī',
    primaryColor: Color(0xFF2E5E3E),
    accentColor: Color(0xFF74C99A),
    icon: Icons.content_cut,
    imagePath: 'assets/images/hajj/haircut.png',
  ),
];
