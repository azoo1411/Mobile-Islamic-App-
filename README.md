# تطبيق إسلامي عربي متكامل 🕌

تطبيق موبايل إسلامي شامل مبني بـ Flutter مع دعم كامل للغة العربية واتجاه RTL.

---

## المميزات

| الميزة | الوصف | الحالة |
|--------|-------|--------|
| القرآن الكريم | نص كامل + تلاوة صوتية + تفسير + بحث | ✅ MVP |
| الأحاديث النبوية | البخاري + مسلم + تصنيف بالأبواب + بحث | ✅ MVP |
| أوقات الصلاة | GPS + إشعارات الأذان + طرق حساب متعددة | ✅ MVP |
| اتجاه القبلة | بوصلة تفاعلية | ✅ MVP |
| مكتبة القصائد | مدح النبي، أندلسيات، حكم، صبر، ابتهالات | ✅ MVP |
| وضع ليلي | دعم كامل | ✅ MVP |
| تحكم حجم الخط | للقرآن والنصوص | ✅ MVP |

---

## التقنيات المستخدمة

### Mobile (Flutter)
```
Flutter 3.x + Dart 3.x
├── State: flutter_riverpod 2.x
├── Navigation: go_router 13.x
├── Database: drift (SQLite) — Offline-First
├── Audio: just_audio
├── Prayer Times: adhan (Dart)
├── Qibla: flutter_qiblah
├── Notifications: flutter_local_notifications
└── Location: geolocator
```

### Backend (FastAPI)
```
FastAPI + Python 3.12
├── Database: PostgreSQL 16 (async via asyncpg)
├── Cache: Redis 7
├── ORM: SQLAlchemy 2.x async
└── Deployment: Docker Compose
```

---

## مصادر البيانات

| المحتوى | المصدر |
|---------|--------|
| نص القرآن (عثماني) | [tanzil.net](https://tanzil.net) |
| تلاوات صوتية | [everyayah.com](https://everyayah.com) |
| الأحاديث | [sunnah.com API](https://sunnah.com/developers) |
| أوقات الصلاة | حساب محلي بمكتبة adhan |
| القصائد | مختارات مُدرجة يدوياً |

---

## الخطوط المستخدمة

| الخط | الاستخدام |
|------|-----------|
| **Amiri Quran** | نص القرآن الكريم |
| **Amiri** | العناوين والقصائد |
| **Noto Naskh Arabic** | واجهة المستخدم العامة |

> تحميل الخطوط من [Google Fonts](https://fonts.google.com) أو [amirifont.org](https://www.amirifont.org)
> وضعها في `assets/fonts/`

---

## هيكل المشروع

```
lib/
├── main.dart                   # نقطة الدخول
├── app.dart                    # MaterialApp + RTL locale
├── core/
│   ├── theme/                  # ألوان، خطوط، ثيم
│   ├── constants/              # ثوابت التطبيق
│   ├── utils/                  # مساعدات الأرقام العربية
│   ├── widgets/                # ويدجت مشتركة
│   └── router/                 # go_router navigation
├── features/
│   ├── home/                   # الشاشة الرئيسية
│   ├── quran/                  # القرآن الكريم
│   ├── hadith/                 # الأحاديث النبوية
│   ├── prayer_times/           # أوقات الصلاة
│   ├── qibla/                  # اتجاه القبلة
│   └── poetry/                 # المكتبة الشعرية
├── services/                   # صوت، إشعارات، موقع
└── database/                   # Drift schema + DAOs
```

---

## تشغيل المشروع

### 1. تحضير الخطوط
ضع ملفات الخطوط في `assets/fonts/`:
- `AmiriQuran-Regular.ttf`
- `Amiri-Regular.ttf`
- `Amiri-Bold.ttf`
- `NotoNaskhArabic-Regular.ttf`
- `NotoNaskhArabic-Bold.ttf`

### 2. تحضير بيانات القرآن
تحميل ملف `quran.json` من tanzil.net بتنسيق:
```json
[{"surah": 1, "ayah": 1, "text": "...", "text_uthmani": "...", "page": 1, "juz": 1, "hizb": 1}]
```
وضعه في `assets/data/quran.json`

### 3. تشغيل Flutter
```bash
flutter pub get
dart run build_runner build
flutter run
```

### 4. تشغيل Backend
```bash
cd backend
docker-compose up -d
```

---

## خريطة الطريق (Roadmap)

- [ ] تفسير ابن كثير / السعدي (تحميل إضافي)
- [ ] تتبع حفظ القرآن
- [ ] مسبحة رقمية
- [ ] ورد يومي قابل للتخصيص
- [ ] مزامنة السحابة (Firebase)
- [ ] خريطة المساجد القريبة
- [ ] بحث صوتي بالعربية

---

## الترخيص

هذا المشروع مفتوح المصدر للاستخدام غير التجاري. نص القرآن الكريم محفوظ وفق شروط tanzil.net.
