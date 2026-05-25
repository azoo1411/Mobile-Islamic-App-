# المصحف الرقمي — Mobile Islamic App

تطبيق قرآن كريم بتصميم **Modern Islamic Luxury UI** مبني على Expo (React Native).

---

## التصميم

| اللون | الدور |
|---|---|
| `#FAF7F0` | خلفية عاجية دافئة |
| `#C8A96E` | ذهبي رئيسي |
| `#1B4332` | أخضر إسلامي داكن |
| `#0D1117` | خلفية الوضع الليلي |

---

## الشاشات

| الشاشة | الوصف |
|---|---|
| **فهرس السور** | قائمة ١١٤ سورة مع بحث وفلترة |
| **شاشة القراءة** | نص قرآني كامل + زر تركيز + ورقة ترجمة سفلية |
| **البحث** | بحث في الآيات بالعربية والإنجليزية |
| **التلاوة** | مشغل صوت مع موجة صوتية وقائمة قراء |
| **الإعدادات** | ثيم / حجم الخط / الترجمة / القارئ |

---

## هيكل المشروع

```
src/
├── design-system/   # ألوان، خطوط، مسافات، ظلال
├── context/         # ThemeContext (light/dark/auto + font size)
├── data/            # بيانات القرآن والقراء
├── components/      # GlassHeader · FloatingTabBar · VerseCard · SurahCard · TranslationSheet · BismillahHeader
└── screens/         # SurahIndex · QuranReading · Search · Recitation · Settings
```

---

## التشغيل

```bash
npm install
npx expo start
```

---

## المكتبات الرئيسية

- `expo-blur` — Glassmorphism للهيدر والـ nav bar
- `expo-linear-gradient` — تدرجات لوني
- `expo-haptics` — ردود فعل لمسية
- `react-native-reanimated` — حركات سلسة
- `@expo-google-fonts/amiri` — خط عربي للنص القرآني
- `@expo-google-fonts/nunito` — خط للواجهة
