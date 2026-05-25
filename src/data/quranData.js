// ─── Surah Metadata (all 114) ────────────────────────────────────────────────
export const surahs = [
  { id:1,  nameAr:'الْفَاتِحَة',    nameEn:'Al-Fatihah',    nameMeaning:'The Opening',       verses:7,   juz:1,  page:1,   type:'Meccan',   typeAr:'مكية'  },
  { id:2,  nameAr:'الْبَقَرَة',     nameEn:'Al-Baqarah',    nameMeaning:'The Cow',           verses:286, juz:1,  page:2,   type:'Medinan',  typeAr:'مدنية' },
  { id:3,  nameAr:'آلِ عِمْرَان',   nameEn:"Ali 'Imran",    nameMeaning:'Family of Imran',   verses:200, juz:3,  page:50,  type:'Medinan',  typeAr:'مدنية' },
  { id:4,  nameAr:'النِّسَاء',      nameEn:"An-Nisa'",      nameMeaning:'The Women',         verses:176, juz:4,  page:77,  type:'Medinan',  typeAr:'مدنية' },
  { id:5,  nameAr:'الْمَائِدَة',    nameEn:"Al-Ma'idah",    nameMeaning:'The Table Spread',  verses:120, juz:6,  page:106, type:'Medinan',  typeAr:'مدنية' },
  { id:6,  nameAr:'الْأَنْعَام',    nameEn:"Al-An'am",      nameMeaning:'The Cattle',        verses:165, juz:7,  page:128, type:'Meccan',   typeAr:'مكية'  },
  { id:7,  nameAr:'الْأَعْرَاف',    nameEn:"Al-A'raf",      nameMeaning:'The Heights',       verses:206, juz:8,  page:151, type:'Meccan',   typeAr:'مكية'  },
  { id:8,  nameAr:'الْأَنْفَال',    nameEn:'Al-Anfal',       nameMeaning:'The Spoils of War', verses:75,  juz:9,  page:177, type:'Medinan',  typeAr:'مدنية' },
  { id:9,  nameAr:'التَّوْبَة',     nameEn:'At-Tawbah',      nameMeaning:'The Repentance',    verses:129, juz:10, page:187, type:'Medinan',  typeAr:'مدنية', noBismillah:true },
  { id:10, nameAr:'يُونُس',         nameEn:'Yunus',          nameMeaning:'Jonah',             verses:109, juz:11, page:208, type:'Meccan',   typeAr:'مكية'  },
  { id:11, nameAr:'هُود',           nameEn:'Hud',            nameMeaning:'Hud',               verses:123, juz:11, page:221, type:'Meccan',   typeAr:'مكية'  },
  { id:12, nameAr:'يُوسُف',         nameEn:'Yusuf',          nameMeaning:'Joseph',            verses:111, juz:12, page:235, type:'Meccan',   typeAr:'مكية'  },
  { id:13, nameAr:'الرَّعْد',       nameEn:'Ar-Ra\'d',       nameMeaning:'The Thunder',       verses:43,  juz:13, page:249, type:'Medinan',  typeAr:'مدنية' },
  { id:14, nameAr:'إِبْرَاهِيم',    nameEn:'Ibrahim',        nameMeaning:'Abraham',           verses:52,  juz:13, page:255, type:'Meccan',   typeAr:'مكية'  },
  { id:15, nameAr:'الْحِجْر',       nameEn:'Al-Hijr',        nameMeaning:'The Rocky Tract',   verses:99,  juz:14, page:262, type:'Meccan',   typeAr:'مكية'  },
  { id:16, nameAr:'النَّحْل',       nameEn:'An-Nahl',        nameMeaning:'The Bee',           verses:128, juz:14, page:267, type:'Meccan',   typeAr:'مكية'  },
  { id:17, nameAr:'الْإِسْرَاء',    nameEn:"Al-Isra'",       nameMeaning:'The Night Journey', verses:111, juz:15, page:282, type:'Meccan',   typeAr:'مكية'  },
  { id:18, nameAr:'الْكَهْف',       nameEn:'Al-Kahf',        nameMeaning:'The Cave',          verses:110, juz:15, page:293, type:'Meccan',   typeAr:'مكية'  },
  { id:19, nameAr:'مَرْيَم',        nameEn:'Maryam',         nameMeaning:'Mary',              verses:98,  juz:16, page:305, type:'Meccan',   typeAr:'مكية'  },
  { id:20, nameAr:'طه',             nameEn:'Ta-Ha',          nameMeaning:'Ta-Ha',             verses:135, juz:16, page:312, type:'Meccan',   typeAr:'مكية'  },
  { id:36, nameAr:'يس',             nameEn:'Ya-Sin',         nameMeaning:'Ya Sin',            verses:83,  juz:22, page:440, type:'Meccan',   typeAr:'مكية'  },
  { id:55, nameAr:'الرَّحْمَٰن',    nameEn:'Ar-Rahman',      nameMeaning:'The Beneficent',    verses:78,  juz:27, page:531, type:'Medinan',  typeAr:'مدنية' },
  { id:56, nameAr:'الْوَاقِعَة',    nameEn:"Al-Waqi'ah",     nameMeaning:'The Inevitable',    verses:96,  juz:27, page:534, type:'Meccan',   typeAr:'مكية'  },
  { id:67, nameAr:'الْمُلْك',       nameEn:'Al-Mulk',        nameMeaning:'The Sovereignty',   verses:30,  juz:29, page:562, type:'Meccan',   typeAr:'مكية'  },
  { id:78, nameAr:'النَّبَأ',       nameEn:"An-Naba'",       nameMeaning:'The Tidings',       verses:40,  juz:30, page:582, type:'Meccan',   typeAr:'مكية'  },
  { id:112,nameAr:'الْإِخْلَاص',    nameEn:'Al-Ikhlas',      nameMeaning:'Sincerity',         verses:4,   juz:30, page:604, type:'Meccan',   typeAr:'مكية'  },
  { id:113,nameAr:'الْفَلَق',       nameEn:'Al-Falaq',       nameMeaning:'The Daybreak',      verses:5,   juz:30, page:604, type:'Meccan',   typeAr:'مكية'  },
  { id:114,nameAr:'النَّاس',        nameEn:'An-Nas',         nameMeaning:'Mankind',           verses:6,   juz:30, page:604, type:'Meccan',   typeAr:'مكية'  },
];

// ─── Full verse text for key surahs ──────────────────────────────────────────
export const verses = {

  // ── Al-Fatihah ──────────────────────────────────────────────────────────────
  1: [
    {
      id:1, surahId:1, number:1,
      text:     'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
      translit: 'Bismillāhir-raḥmānir-raḥīm',
      trans:    'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
      page:1, juz:1,
    },
    {
      id:2, surahId:1, number:2,
      text:     'ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ',
      translit: 'Al-ḥamdu lillāhi rabbil-ʿālamīn',
      trans:    'All praise is due to Allah, Lord of the worlds.',
      page:1, juz:1,
    },
    {
      id:3, surahId:1, number:3,
      text:     'ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
      translit: 'Ar-raḥmānir-raḥīm',
      trans:    'The Entirely Merciful, the Especially Merciful.',
      page:1, juz:1,
    },
    {
      id:4, surahId:1, number:4,
      text:     'مَٰلِكِ يَوۡمِ ٱلدِّينِ',
      translit: 'Māliki yawmid-dīn',
      trans:    'Sovereign of the Day of Recompense.',
      page:1, juz:1,
    },
    {
      id:5, surahId:1, number:5,
      text:     'إِيَّاكَ نَعۡبُدُ وَإِيَّاكَ نَسۡتَعِينُ',
      translit: 'Iyyāka naʿbudu wa-iyyāka nastaʿīn',
      trans:    'It is You we worship and You we ask for help.',
      page:1, juz:1,
    },
    {
      id:6, surahId:1, number:6,
      text:     'ٱهۡدِنَا ٱلصِّرَٰطَ ٱلۡمُسۡتَقِيمَ',
      translit: 'Ihdinas-ṣirāṭal-mustaqīm',
      trans:    'Guide us to the straight path —',
      page:1, juz:1,
    },
    {
      id:7, surahId:1, number:7,
      text:     'صِرَٰطَ ٱلَّذِينَ أَنۡعَمۡتَ عَلَيۡهِمۡ غَيۡرِ ٱلۡمَغۡضُوبِ عَلَيۡهِمۡ وَلَا ٱلضَّآلِّينَ',
      translit: 'Ṣirāṭal-ladhīna anʿamta ʿalayhim ghayril-maghḍūbi ʿalayhim wa-laḍ-ḍāllīn',
      trans:    'The path of those upon whom You have bestowed favor, not of those who have evoked anger or of those who are astray.',
      page:1, juz:1,
    },
  ],

  // ── Al-Ikhlas ───────────────────────────────────────────────────────────────
  112: [
    {
      id:1, surahId:112, number:1,
      text:     'قُلۡ هُوَ ٱللَّهُ أَحَدٌ',
      translit: 'Qul huwa llāhu aḥad',
      trans:    'Say: He is Allah, the One.',
      page:604, juz:30,
    },
    {
      id:2, surahId:112, number:2,
      text:     'ٱللَّهُ ٱلصَّمَدُ',
      translit: 'Allāhuṣ-ṣamad',
      trans:    'Allah, the Eternal Refuge.',
      page:604, juz:30,
    },
    {
      id:3, surahId:112, number:3,
      text:     'لَمۡ يَلِدۡ وَلَمۡ يُولَدۡ',
      translit: 'Lam yalid wa-lam yūlad',
      trans:    'He neither begets nor is born.',
      page:604, juz:30,
    },
    {
      id:4, surahId:112, number:4,
      text:     'وَلَمۡ يَكُن لَّهُۥ كُفُوًا أَحَدٌ',
      translit: 'Wa-lam yakun lahū kufuwan aḥad',
      trans:    'Nor is there to Him any equivalent.',
      page:604, juz:30,
    },
  ],

  // ── An-Nas ──────────────────────────────────────────────────────────────────
  114: [
    {
      id:1, surahId:114, number:1,
      text:     'قُلۡ أَعُوذُ بِرَبِّ ٱلنَّاسِ',
      translit: 'Qul aʿūdhu bi-rabbi-n-nās',
      trans:    'Say: I seek refuge in the Lord of mankind,',
      page:604, juz:30,
    },
    {
      id:2, surahId:114, number:2,
      text:     'مَلِكِ ٱلنَّاسِ',
      translit: 'Maliki-n-nās',
      trans:    'The Sovereign of mankind,',
      page:604, juz:30,
    },
    {
      id:3, surahId:114, number:3,
      text:     'إِلَٰهِ ٱلنَّاسِ',
      translit: 'Ilāhi-n-nās',
      trans:    'The God of mankind,',
      page:604, juz:30,
    },
    {
      id:4, surahId:114, number:4,
      text:     'مِن شَرِّ ٱلۡوَسۡوَاسِ ٱلۡخَنَّاسِ',
      translit: 'Min sharri-l-waswāsi-l-khannās',
      trans:    'From the evil of the retreating whisperer',
      page:604, juz:30,
    },
    {
      id:5, surahId:114, number:5,
      text:     'ٱلَّذِي يُوَسۡوِسُ فِي صُدُورِ ٱلنَّاسِ',
      translit: 'Alladhī yuwaswisu fī ṣudūri-n-nās',
      trans:    'Who whispers in the breasts of mankind,',
      page:604, juz:30,
    },
    {
      id:6, surahId:114, number:6,
      text:     'مِنَ ٱلۡجِنَّةِ وَٱلنَّاسِ',
      translit: 'Mina-l-jinnati wa-n-nās',
      trans:    'From among the jinn and mankind.',
      page:604, juz:30,
    },
  ],
};

// ─── Reciters ─────────────────────────────────────────────────────────────────
export const reciters = [
  { id: 1, nameAr: 'عبد الباسط عبد الصمد',  nameEn: 'Abdul Basit',        style: 'Murattal' },
  { id: 2, nameAr: 'مشاري راشد العفاسي',    nameEn: 'Mishary Alafasy',     style: 'Murattal' },
  { id: 3, nameAr: 'سعد الغامدي',           nameEn: 'Saad Al-Ghamdi',      style: 'Murattal' },
  { id: 4, nameAr: 'محمود خليل الحصري',     nameEn: 'Mahmoud Al-Hussary',  style: 'Murattal' },
  { id: 5, nameAr: 'ماهر المعيقلي',         nameEn: 'Maher Al-Muaiqly',    style: 'Murattal' },
];

// ─── Helpers ──────────────────────────────────────────────────────────────────
export function getSurahById(id) {
  return surahs.find(s => s.id === id);
}

export function getVerses(surahId) {
  return verses[surahId] ?? [];
}

export const juzList = Array.from({ length: 30 }, (_, i) => i + 1);
