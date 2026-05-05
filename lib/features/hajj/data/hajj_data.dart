import 'package:flutter/material.dart';

class HajjStep {
  final String text;
  bool isCompleted;
  HajjStep({required this.text, this.isCompleted = false});
}

class HajjRitual {
  final String id;
  final String titleArabic;
  final String titleEnglish;
  final String dayLabel;      // e.g. "٨ ذو الحجة"
  final String descriptionArabic;
  final List<String> steps;
  final String importantTip;
  final String? dua;
  final String? duaTransliteration;
  final Color primaryColor;
  final Color accentColor;
  final IconData icon;
  final String imagePrompt; // AI image generation prompt

  const HajjRitual({
    required this.id,
    required this.titleArabic,
    required this.titleEnglish,
    required this.dayLabel,
    required this.descriptionArabic,
    required this.steps,
    required this.importantTip,
    this.dua,
    this.duaTransliteration,
    required this.primaryColor,
    required this.accentColor,
    required this.icon,
    required this.imagePrompt,
  });
}

const List<HajjRitual> kHajjRituals = [
  // ─── 1. الإحرام ────────────────────────────────────────────────────────────
  HajjRitual(
    id: 'ihram',
    titleArabic: 'الإحرام',
    titleEnglish: 'Ihram',
    dayLabel: '٨ ذو الحجة',
    descriptionArabic:
        'الدخول في الحالة المقدسة بالنية والتلبية، انطلاقاً من الميقات.',
    steps: [
      'اغتسل غسل الإحرام وتطيّب قبل ارتداء ملابس الإحرام',
      'البس ثوبي الإحرام الأبيضين (للرجال) أو الثياب الشرعية الساترة (للنساء)',
      'صلِّ ركعتي سنة الإحرام',
      'انوِ الحج عند الميقات بقلبك ولسانك',
      'ردّد التلبية بصوت عالٍ: لبيك اللهم لبيك…',
    ],
    importantTip:
        'تجنّب استخدام العطر والصابون المعطّر بعد الإحرام — المحظورات تبدأ فور النية.',
    dua: 'لَبَّيْكَ اللّٰهُمَّ لَبَّيْكَ، لَبَّيْكَ لَا شَرِيكَ لَكَ لَبَّيْكَ،\nإِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ، لَا شَرِيكَ لَكَ',
    duaTransliteration:
        'Labbayk Allahumma labbayk, labbayk lā sharīka laka labbayk,\ninna l-ḥamda wa-n-niʿmata laka wa-l-mulk, lā sharīka lak',
    primaryColor: Color(0xFF8B7035),
    accentColor: Color(0xFFD4AF37),
    icon: Icons.spa_outlined,
    imagePrompt:
        'Modern Islamic minimal illustration of two white Ihram garments draped gently on a stone ledge, soft golden morning light streaming from the right, desert landscape in background, beige and white tones, spiritual atmosphere, no faces, no text, square 1:1 format',
  ),

  // ─── 2. منى ────────────────────────────────────────────────────────────────
  HajjRitual(
    id: 'mina',
    titleArabic: 'منى',
    titleEnglish: 'Mina',
    dayLabel: '٨ ذو الحجة',
    descriptionArabic:
        'الانتقال إلى منى والمبيت فيها ليلة التروية استعداداً ليوم عرفة.',
    steps: [
      'توجّه إلى منى في صباح اليوم الثامن من ذي الحجة',
      'أدِّ صلاة الظهر والعصر والمغرب والعشاء والفجر قصراً دون جمع',
      'ابِت ليلتك في منى — المبيت سنة مؤكدة',
      'أكثر من الذكر والتلاوة وإحياء الوقت بالعبادة',
      'استرح جيداً؛ فيوم عرفة يستلزم طاقة وتركيزاً كاملاً',
    ],
    importantTip:
        'الصلوات في منى تُقصر إلى ركعتين دون جمع — احرص على معرفة مواقيتها.',
    dua: 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
    duaTransliteration:
        'Rabbanā ātinā fī d-dunyā ḥasanatan wa fī l-ākhirati ḥasanatan wa qinā ʿadhāba n-nār',
    primaryColor: Color(0xFF2D6A4F),
    accentColor: Color(0xFF52B788),
    icon: Icons.nights_stay_outlined,
    imagePrompt:
        'Modern Islamic minimal illustration of white tents in the valley of Mina at twilight, soft golden and green tones, distant mountains, silhouettes of pilgrims resting, spiritual peaceful atmosphere, no faces, no text, square 1:1 format',
  ),

  // ─── 3. عرفات ──────────────────────────────────────────────────────────────
  HajjRitual(
    id: 'arafat',
    titleArabic: 'الوقوف بعرفة',
    titleEnglish: 'Arafat',
    dayLabel: '٩ ذو الحجة',
    descriptionArabic:
        'ركن الحج الأعظم — الوقوف في سهل عرفة من الزوال حتى غروب الشمس.',
    steps: [
      'انتقل من منى إلى عرفة في صباح اليوم التاسع',
      'صلِّ الظهر والعصر جمعاً وقصراً مع سماع خطبة عرفة',
      'قف في أي مكان داخل حدود عرفة واستقبل القبلة',
      'أكثر من الدعاء والذكر والاستغفار والبكاء والتضرع',
      'لا تغادر عرفة قبل غروب الشمس — ركن لا يصح الحج بتركه',
    ],
    importantTip:
        'قال ﷺ: "الحج عرفة" — هذا أعظم أركان الحج، فأحضر قلبك كله لله.',
    dua: 'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ\nوَهُوَ عَلَىٰ كُلِّ شَيْءٍ قَدِيرٌ',
    duaTransliteration:
        'Lā ilāha illa llāhu waḥdahu lā sharīka lah, lahu l-mulku wa lahu l-ḥamdu wa huwa ʿalā kulli shayʾin qadīr',
    primaryColor: Color(0xFFC08000),
    accentColor: Color(0xFFF0C040),
    icon: Icons.wb_sunny_outlined,
    imagePrompt:
        'Modern Islamic minimal illustration of the vast plain of Arafat at golden hour, warm amber and gold tones, silhouettes of thousands of pilgrims standing in prayer, soft spiritual light rays from above, Jabal al-Rahmah hill in background, beige and gold palette, no faces, no text, square 1:1 format',
  ),

  // ─── 4. المزدلفة ───────────────────────────────────────────────────────────
  HajjRitual(
    id: 'muzdalifah',
    titleArabic: 'المزدلفة',
    titleEnglish: 'Muzdalifah',
    dayLabel: '٩–١٠ ذو الحجة',
    descriptionArabic:
        'المبيت تحت النجوم وجمع الحصيات، بعد مغادرة عرفة ليلاً.',
    steps: [
      'غادر عرفة بعد غروب الشمس باتجاه المزدلفة بهدوء',
      'صلِّ المغرب والعشاء جمعاً وقصراً لدى وصولك',
      'اجمع ٤٩ حصاة صغيرة (بحجم حبة الحمص) لرمي الجمرات',
      'نَم في الهواء الطلق — المبيت بالمزدلفة واجب',
      'صلِّ الفجر، وأكثر من الدعاء حتى قُبيل الشروق، ثم اتجه لمنى',
    ],
    importantTip:
        'يُرخَّص للضعفاء والمرضى والنساء المغادرة بعد منتصف الليل.',
    dua: 'اللَّهُمَّ إِنَّكَ عَفُوٌّ كَرِيمٌ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',
    duaTransliteration: 'Allāhumma innaka ʿafuwwun karīmun tuḥibbu l-ʿafwa faʿfu ʿannī',
    primaryColor: Color(0xFF1A2F4B),
    accentColor: Color(0xFF4A90D9),
    icon: Icons.star_outline,
    imagePrompt:
        'Modern Islamic minimal illustration of a clear starry desert night sky over Muzdalifah, deep navy blue and indigo tones, silhouettes of pilgrims sleeping on the open ground, soft glowing moon, small pebbles in foreground, spiritual calm atmosphere, no faces, no text, square 1:1 format',
  ),

  // ─── 5. رمي الجمرات ────────────────────────────────────────────────────────
  HajjRitual(
    id: 'jamarat',
    titleArabic: 'رمي الجمرات',
    titleEnglish: 'Stoning the Jamarat',
    dayLabel: '١٠–١٣ ذو الحجة',
    descriptionArabic:
        'رمي الجمرات تعبيراً عن رفض الشيطان، اقتداءً بسيدنا إبراهيم عليه السلام.',
    steps: [
      'في اليوم العاشر: ارمِ جمرة العقبة الكبرى فقط بـ ٧ حصيات',
      'قُل "الله أكبر" مع كل رمية',
      'في أيام التشريق (١١ و١٢ و١٣): ارمِ الجمرات الثلاث بـ ٧ حصيات لكل منها',
      'الترتيب: الصغرى ← الوسطى ← الكبرى',
      'يجوز النفر الأول في اليوم الثاني عشر لمن أراد التعجل',
    ],
    importantTip:
        'الرمي رمزي وليس غضباً — ارمِ بهدوء وتجنّب الزحام الشديد.',
    dua: 'اللَّهُمَّ اجْعَلْهُ حَجًّا مَبْرُورًا وَسَعْيًا مَشْكُورًا وَذَنْبًا مَغْفُورًا',
    duaTransliteration:
        'Allāhumma jʿalhu ḥajjan mabrūran wa saʿyan mashkūran wa dhanban maghfūrā',
    primaryColor: Color(0xFF5C4A3A),
    accentColor: Color(0xFFB08050),
    icon: Icons.radio_button_unchecked,
    imagePrompt:
        'Modern Islamic minimal illustration of small smooth pebbles arranged in a circle on sandy ground, warm earthy tones, beige and brown palette, soft dramatic lighting, one pebble mid-air in motion suggesting throwing, spiritual symbolic feel, no people, no text, square 1:1 format',
  ),

  // ─── 6. النحر ──────────────────────────────────────────────────────────────
  HajjRitual(
    id: 'sacrifice',
    titleArabic: 'الهدي والنحر',
    titleEnglish: 'Sacrifice',
    dayLabel: '١٠ ذو الحجة',
    descriptionArabic:
        'ذبح الهدي تقرباً إلى الله، اقتداءً بإبراهيم عليه السلام وفداءه.',
    steps: [
      'الهدي واجب على المتمتع والقارن — تحقق من حكمك',
      'يُؤدَّى النحر يوم عيد الأضحى (١٠ ذو الحجة)',
      'يمكنك التوكيل للذبح عبر بنك الهدي أو شركة الحج',
      'اللحم يُوزَّع على الفقراء والحاج وذويه',
      'بعد النحر يحل لك التحلل الأصغر — خلع الإحرام واللباس العادي',
    ],
    importantTip:
        'معظم باقات الحج تتضمن خدمة الهدي المنظّمة — تأكد من التنسيق مع مجموعتك.',
    primaryColor: Color(0xFF7A3B2E),
    accentColor: Color(0xFFD4714A),
    icon: Icons.volunteer_activism_outlined,
    imagePrompt:
        'Modern Islamic minimal illustration symbolizing sacrifice and gratitude, abstract golden crescent and star motif, warm russet and cream tones, stylized lamb silhouette in soft light, spiritual and reverent mood, no blood or graphic content, elegant and peaceful, no text, square 1:1 format',
  ),

  // ─── 7. الحلق أو التقصير ───────────────────────────────────────────────────
  HajjRitual(
    id: 'haircut',
    titleArabic: 'الحلق أو التقصير',
    titleEnglish: 'Shaving or Cutting Hair',
    dayLabel: '١٠ ذو الحجة',
    descriptionArabic:
        'حلق الرأس أو تقصيره إيذاناً بالخروج من الإحرام والتحلل من محظوراته.',
    steps: [
      'يُنفَّذ بعد الرمي والنحر يوم العاشر من ذي الحجة',
      'الرجال: الأفضل حلق الرأس كاملاً؛ التقصير مجزئ',
      'النساء: قصّ قدر أُنملة من طرف الشعر فقط — الحلق محرّم عليهن',
      'بعد الحلق يحل التحلل الأصغر: اللباس، الطيب، كل المحظورات ما عدا الجماع',
      'الجماع لا يحل إلا بعد طواف الإفاضة',
    ],
    importantTip:
        'حلق الرأس أفضل من التقصير وأجزأ — اتّبع السنة إن استطعت.',
    primaryColor: Color(0xFF3D6B52),
    accentColor: Color(0xFF74C99A),
    icon: Icons.content_cut,
    imagePrompt:
        'Modern Islamic minimal illustration of a pair of elegant scissors resting beside white Ihram cloth on a clean surface, soft natural light, sage green and white tones, symbolic sense of transformation and renewal, minimal clean composition, no faces, no text, square 1:1 format',
  ),

  // ─── 8. طواف الإفاضة ───────────────────────────────────────────────────────
  HajjRitual(
    id: 'tawaf',
    titleArabic: 'طواف الإفاضة',
    titleEnglish: 'Tawaf al-Ifadah',
    dayLabel: '١٠–١٢ ذو الحجة',
    descriptionArabic:
        'ركن من أركان الحج — الطواف سبعة أشواط حول الكعبة المشرفة.',
    steps: [
      'توجّه إلى المسجد الحرام في مكة المكرمة',
      'ابدأ الطواف من الحجر الأسود مستلماً له أو مشيراً إليه بيدك',
      'طُف سبعة أشواط عكس اتجاه عقارب الساعة',
      'الرجال: يضطبعون (كشف الكتف الأيمن) في الأشواط الثلاثة الأولى',
      'بعد الطواف: صلِّ ركعتين عند مقام إبراهيم، واشرب من ماء زمزم',
    ],
    importantTip:
        'حاول الطواف في ساعات الفجر المبكرة أو منتصف الليل لتفادي الزحام.',
    dua: 'سُبْحَانَ اللهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللهُ وَاللهُ أَكْبَرُ',
    duaTransliteration:
        'Subḥāna llāhi wa l-ḥamdu lillāhi wa lā ilāha illa llāhu wa llāhu akbar',
    primaryColor: Color(0xFF1B4A2E),
    accentColor: Color(0xFFD4AF37),
    icon: Icons.rotate_right,
    imagePrompt:
        'Modern Islamic minimal illustration of the Kaaba from above with white-clad pilgrims circling in a perfect spiral, overhead aerial view, dark green and gold color scheme, soft spiritual light emanating from center, geometric sacred geometry patterns blending with the scene, majestic and serene, no faces, no text, square 1:1 format',
  ),

  // ─── 9. السعي ──────────────────────────────────────────────────────────────
  HajjRitual(
    id: 'sai',
    titleArabic: 'السعي بين الصفا والمروة',
    titleEnglish: "Sa'i",
    dayLabel: '١٠–١٢ ذو الحجة',
    descriptionArabic:
        'السعي سبعة أشواط اقتداءً بأم إسماعيل هاجر في بحثها عن الماء.',
    steps: [
      'ابدأ من جبل الصفا بعد الطواف مباشرة',
      'استقبل القبلة عند الصفا وادعُ الله رافعاً يديك',
      'امشِ باتجاه المروة — الشوط الأول من الصفا إلى المروة',
      'الرجال: يسرعون المشي في المسافة المحددة بعلامات خضراء',
      'أكمل ٧ أشواط، ينتهي السعي عند المروة — ثم تحقق تحللك الكامل',
    ],
    importantTip:
        'تأمل في معنى السعي — أنت تسير على خطى هاجر عليها السلام في يقينها بالله.',
    dua: 'إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ',
    duaTransliteration: 'Inna ṣ-ṣafā wa l-marwata min shaʿāʾiri llāh',
    primaryColor: Color(0xFF8B6914),
    accentColor: Color(0xFFD4AF37),
    icon: Icons.swap_horiz,
    imagePrompt:
        'Modern Islamic minimal illustration of the Safa and Marwa corridor inside Masjid al-Haram, warm golden and cream tones, silhouettes of pilgrims walking between two elevated platforms, soft arched architecture, spiritual warm light, sense of journey and faith, no faces, no text, square 1:1 format',
  ),
];
