import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'app.dart';
import 'services/notification_service.dart';
import 'services/database_seeder.dart';
import 'database/app_database.dart';
import 'core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  tz.initializeTimeZones();
  final localTz = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(localTz));

  await NotificationService.instance.initialize();
  // Reschedule 7-day adhan using last-known coordinates (works with app closed)
  await NotificationService.instance.scheduleFromSavedLocation();

  final db = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: _AppLoader(db: db),
    ),
  );
}

/// Shows a loading screen while seeding the database on first launch,
/// then hands off to the real app.
class _AppLoader extends StatefulWidget {
  final AppDatabase db;
  const _AppLoader({required this.db});

  @override
  State<_AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<_AppLoader> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _seed();
  }

  Future<void> _seed() async {
    await DatabaseSeeder(widget.db).seedIfNeeded();
    // Request notification permission (Android 13+) so adhan alerts work
    await Permission.notification.request();
    if (mounted) setState(() => _ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_ready) return const IslamicApp();

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mosque, color: Colors.white, size: 64),
              SizedBox(height: 24),
              Text(
                'الوجهة القبلية',
                style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 32),
              CircularProgressIndicator(
                color: Color(0xFFD4AF37),
                strokeWidth: 2.5,
              ),
              SizedBox(height: 16),
              Text(
                'جاري تحميل البيانات...',
                style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 14,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
