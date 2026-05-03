import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../../core/theme/app_colors.dart';

const double _kaabaLat = 21.422487;
const double _kaabaLon = 39.826206;

double _toRad(double deg) => deg * math.pi / 180;
double _toDeg(double rad) => rad * 180 / math.pi;

double _qiblaAngle(double lat, double lon) {
  final dLon = _toRad(_kaabaLon - lon);
  final lat1 = _toRad(lat);
  final lat2 = _toRad(_kaabaLat);
  final y = math.sin(dLon) * math.cos(lat2);
  final x = math.cos(lat1) * math.sin(lat2) -
      math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
  return (_toDeg(math.atan2(y, x)) + 360) % 360;
}

double _distanceTo(double lat, double lon) {
  const R = 6371.0;
  final dlat = _toRad(_kaabaLat - lat);
  final dlon = _toRad(_kaabaLon - lon);
  final a = math.sin(dlat / 2) * math.sin(dlat / 2) +
      math.cos(_toRad(lat)) *
          math.cos(_toRad(_kaabaLat)) *
          math.sin(dlon / 2) *
          math.sin(dlon / 2);
  return R * 2 * math.asin(math.sqrt(a));
}

class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});

  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseCtrl;

  StreamSubscription<MagnetometerEvent>? _magSub;
  StreamSubscription<AccelerometerEvent>? _accelSub;

  bool _permissionGranted = false;
  bool _locationReady = false;
  double _qiblaAngleDeg = 0;
  double _distanceKm = 0;
  double _compassHeading = 0;
  bool _isAligned = false;
  double _alignmentError = 180;

  double _mx = 0, _my = 0, _mz = 0;
  double _ax = 0, _ay = 0, _az = 9.8;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _init();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _magSub?.cancel();
    _accelSub?.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    final status = await Permission.location.request();
    if (!mounted) return;
    if (!status.isGranted) {
      setState(() => _permissionGranted = false);
      return;
    }
    setState(() => _permissionGranted = true);

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      if (mounted) {
        setState(() {
          _qiblaAngleDeg = _qiblaAngle(pos.latitude, pos.longitude);
          _distanceKm = _distanceTo(pos.latitude, pos.longitude);
          _locationReady = true;
        });
      }
    } catch (_) {}

    _accelSub = accelerometerEventStream().listen((e) {
      _ax = e.x;
      _ay = e.y;
      _az = e.z;
      _computeHeading();
    });
    _magSub = magnetometerEventStream().listen((e) {
      _mx = e.x;
      _my = e.y;
      _mz = e.z;
      _computeHeading();
    });
  }

  void _computeHeading() {
    if (!mounted) return;
    final accMag = math.sqrt(_ax * _ax + _ay * _ay + _az * _az);
    if (accMag < 0.1) return;

    final gx = _ax / accMag;
    final gy = _ay / accMag;
    final gz = _az / accMag;

    // Tilt-compensated heading
    final pitch = math.atan2(-gx, gz);
    final roll = math.atan2(gy, math.sqrt(gx * gx + gz * gz));

    final hx = _mx * math.cos(pitch) + _mz * math.sin(pitch);
    final hy = _mx * math.sin(roll) * math.sin(pitch) +
        _my * math.cos(roll) -
        _mz * math.sin(roll) * math.cos(pitch);

    final newHeading = (_toDeg(math.atan2(-hy, hx)) + 360) % 360;

    // Smooth with wrap-around handling
    var diff = newHeading - _compassHeading;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;

    setState(() {
      _compassHeading = (_compassHeading + diff * 0.25 + 360) % 360;
      _alignmentError =
          ((_qiblaAngleDeg - _compassHeading) + 360) % 360;
      if (_alignmentError > 180) _alignmentError = 360 - _alignmentError;
      _isAligned = _alignmentError < 8;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF060E1C),
        body: _permissionGranted
            ? (_locationReady ? _buildMain() : _buildLoading())
            : _buildPermissionDenied(),
      ),
    );
  }

  Widget _buildLoading() {
    return _darkBg(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🕋', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 24),
          const CircularProgressIndicator(color: AppColors.gold),
          const SizedBox(height: 16),
          Text(
            'جاري تحديد موقعك...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 15,
              fontFamily: 'NotoNaskhArabic',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMain() {
    final needleAngle = _toRad(_qiblaAngleDeg - _compassHeading);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.4),
              radius: 1.3,
              colors: [
                Color(0xFF1A2F4B),
                Color(0xFF0A1628),
                Color(0xFF060E1C),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        CustomPaint(painter: _StarFieldPainter()),
        SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildStatusBadge(),
              const SizedBox(height: 8),
              Expanded(child: _buildCompass(needleAngle)),
              _buildInfoPanel(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: Colors.white60, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Expanded(
            child: Text(
              'اتجاه القبلة',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'NotoNaskhArabic',
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final color = _isAligned
        ? const Color(0xFF1B9E6A)
        : _alignmentError < 20
            ? Colors.orange
            : AppColors.gold;
    final text = _isAligned
        ? 'أنت تواجه اتجاه القبلة  ✓'
        : _alignmentError < 20
            ? 'اقترب أكثر من الاتجاه'
            : 'استدر نحو الإبرة الذهبية';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          fontFamily: 'NotoNaskhArabic',
        ),
      ),
    );
  }

  Widget _buildCompass(double needleAngle) {
    return LayoutBuilder(builder: (ctx, box) {
      final size = math.min(box.maxWidth, box.maxHeight) * 0.9;
      return Center(
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) => _buildGlow(size),
              ),
              // Rotating compass ring
              RepaintBoundary(
                child: Transform.rotate(
                  angle: -_toRad(_compassHeading),
                  child: CustomPaint(
                    size: Size(size, size),
                    painter: const _CompassRingPainter(),
                  ),
                ),
              ),
              // Inner dial + needle
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) => CustomPaint(
                  size: Size(size * 0.58, size * 0.58),
                  painter: _NeedlePainter(
                    needleAngle: needleAngle,
                    isAligned: _isAligned,
                    alignmentError: _alignmentError,
                    pulse: _pulseCtrl.value,
                  ),
                ),
              ),
              // Ka'ba center button
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, __) => _buildKaabaCenter(),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildGlow(double size) {
    final color = _isAligned ? const Color(0xFF1B9E6A) : AppColors.gold;
    final opacity = _isAligned
        ? 0.20 + 0.15 * math.sin(_pulseCtrl.value * 2 * math.pi)
        : 0.09;
    return Container(
      width: size * 0.62,
      height: size * 0.62,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(opacity),
            blurRadius: 50,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildKaabaCenter() {
    final color = _isAligned ? const Color(0xFF1B9E6A) : AppColors.gold;
    final scale = _isAligned
        ? 1.0 + 0.05 * math.sin(_pulseCtrl.value * 2 * math.pi)
        : 1.0;
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF0C1A2E),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(_isAligned ? 0.6 : 0.3),
              blurRadius: 12,
            ),
          ],
        ),
        child: const Center(
          child: Text('🕋', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }

  Widget _buildInfoPanel() {
    final qibla = _qiblaAngleDeg.toStringAsFixed(1);
    final dist = _distanceKm >= 1000
        ? '${(_distanceKm / 1000).toStringAsFixed(1)} ألف كم'
        : '${_distanceKm.round()} كم';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.gold.withOpacity(0.2)),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _tile('الاتجاه', '$qibla°', Icons.explore_outlined),
            VerticalDivider(
                color: Colors.white.withOpacity(0.12), width: 1),
            _tile('المسافة', dist, Icons.location_on_outlined),
            VerticalDivider(
                color: Colors.white.withOpacity(0.12), width: 1),
            _tile('الوجهة', 'مكة المكرمة', Icons.mosque_outlined),
          ],
        ),
      ),
    );
  }

  Widget _tile(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.gold, size: 20),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoNaskhArabic',
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.45),
            fontSize: 10,
            fontFamily: 'NotoNaskhArabic',
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionDenied() {
    return _darkBg(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🕋', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 28),
          const Text(
            'اتجاه القبلة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'NotoNaskhArabic',
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'يتطلب عرض اتجاه القبلة الإذن بالوصول إلى موقعك',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
                fontFamily: 'NotoNaskhArabic',
                height: 1.8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 36),
          ElevatedButton.icon(
            onPressed: _init,
            icon: const Icon(Icons.location_on),
            label: const Text('السماح بالوصول'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.black87,
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              textStyle: const TextStyle(
                  fontFamily: 'NotoNaskhArabic', fontSize: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _darkBg({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [Color(0xFF1A2F4B), Color(0xFF060E1C)],
        ),
      ),
      child: Center(child: child),
    );
  }
}

// ── Painters ──────────────────────────────────────────────────

class _StarFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final paint = Paint();
    for (int i = 0; i < 90; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.5 + rng.nextDouble() * 1.2;
      final opacity = 0.1 + rng.nextDouble() * 0.35;
      canvas.drawCircle(
          Offset(x, y), r, paint..color = Colors.white.withOpacity(opacity));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _CompassRingPainter extends CustomPainter {
  const _CompassRingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    _ring(canvas, c, r - 1, 2.0, AppColors.gold.withOpacity(0.7));
    _ring(canvas, c, r * 0.74, 1.0, AppColors.gold.withOpacity(0.2));

    for (int deg = 0; deg < 360; deg++) {
      final rad = _toRad(deg.toDouble());
      final sinV = math.sin(rad);
      final cosV = math.cos(rad);

      double len;
      double strokeW;
      Color color;

      if (deg % 90 == 0) {
        len = 22;
        strokeW = 2.5;
        color = deg == 0 ? const Color(0xFFFF6B6B) : AppColors.gold;
      } else if (deg % 45 == 0) {
        len = 14;
        strokeW = 1.5;
        color = AppColors.gold.withOpacity(0.75);
      } else if (deg % 10 == 0) {
        len = 8;
        strokeW = 1.0;
        color = AppColors.gold.withOpacity(0.45);
      } else if (deg % 5 == 0) {
        len = 4;
        strokeW = 0.7;
        color = AppColors.gold.withOpacity(0.25);
      } else {
        continue;
      }

      final outerR = r - 4;
      final innerR = outerR - len;
      canvas.drawLine(
        Offset(c.dx + sinV * innerR, c.dy - cosV * innerR),
        Offset(c.dx + sinV * outerR, c.dy - cosV * outerR),
        Paint()
          ..color = color
          ..strokeWidth = strokeW
          ..strokeCap = StrokeCap.round,
      );
    }

    // Cardinal labels
    _cardinal(canvas, c, r, 0, 'شمال', const Color(0xFFFF8080), true);
    _cardinal(canvas, c, r, 90, 'شرق', AppColors.gold.withOpacity(0.85), false);
    _cardinal(canvas, c, r, 180, 'جنوب', AppColors.gold.withOpacity(0.85), false);
    _cardinal(canvas, c, r, 270, 'غرب', AppColors.gold.withOpacity(0.85), false);

    // Dots at NE, SE, SW, NW
    for (int deg = 45; deg < 360; deg += 90) {
      final rad = _toRad(deg.toDouble());
      canvas.drawCircle(
        Offset(c.dx + math.sin(rad) * (r - 5),
            c.dy - math.cos(rad) * (r - 5)),
        3,
        Paint()..color = AppColors.gold.withOpacity(0.55),
      );
    }
  }

  void _ring(Canvas canvas, Offset c, double r, double w, Color color) {
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = w,
    );
  }

  void _cardinal(Canvas canvas, Offset c, double r, int deg, String text,
      Color color, bool isNorth) {
    final rad = _toRad(deg.toDouble());
    final labelR = r - 44;
    final x = c.dx + math.sin(rad) * labelR;
    final y = c.dy - math.cos(rad) * labelR;

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: isNorth ? 11 : 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'NotoNaskhArabic',
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

class _NeedlePainter extends CustomPainter {
  final double needleAngle;
  final bool isAligned;
  final double alignmentError;
  final double pulse;

  const _NeedlePainter({
    required this.needleAngle,
    required this.isAligned,
    required this.alignmentError,
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    // Background
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFF1C3555), Color(0xFF0A1628)],
          center: const Alignment(-0.2, -0.2),
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );

    // Border
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = AppColors.gold.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Islamic 8-pointed star decoration
    _drawIslamicStar(canvas, c, r * 0.72, AppColors.gold.withOpacity(0.06));

    // Alignment arc
    final fraction = math.max(0.0, 1.0 - alignmentError / 45.0);
    if (fraction > 0.01) {
      final arcColor = isAligned ? const Color(0xFF1B9E6A) : Colors.orange;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r - 7),
        -math.pi / 2 - fraction * math.pi,
        fraction * 2 * math.pi,
        false,
        Paint()
          ..color = arcColor.withOpacity(isAligned ? 0.8 : 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
    }

    // Needle
    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(needleAngle);

    final h = r * 0.74;

    // Shadow
    canvas.drawPath(
      _needlePath(h),
      Paint()
        ..color = AppColors.gold.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Body
    canvas.drawPath(
      _needlePath(h),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.goldLight,
            AppColors.gold,
            AppColors.gold.withOpacity(0.15),
          ],
        ).createShader(Rect.fromLTWH(-6, -h, 12, h * 1.45)),
    );

    // Tip diamond
    final tip = _tipPath(h);
    canvas.drawPath(tip, Paint()..color = AppColors.goldLight);

    if (isAligned) {
      final glow = 0.4 + 0.3 * math.sin(pulse * 2 * math.pi);
      canvas.drawPath(
        tip,
        Paint()
          ..color = const Color(0xFF1B9E6A).withOpacity(glow)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
      );
    }

    canvas.restore();
  }

  Path _needlePath(double h) => Path()
    ..moveTo(0, -h + 18)
    ..lineTo(5, -h * 0.38)
    ..lineTo(3, h * 0.32)
    ..lineTo(-3, h * 0.32)
    ..lineTo(-5, -h * 0.38)
    ..close();

  Path _tipPath(double h) => Path()
    ..moveTo(0, -h)
    ..lineTo(7, -h + 16)
    ..lineTo(0, -h + 22)
    ..lineTo(-7, -h + 16)
    ..close();

  void _drawIslamicStar(
      Canvas canvas, Offset c, double r, Color color) {
    final path = Path();
    for (int i = 0; i < 8; i++) {
      final outer = _toRad(i * 45.0 - 90);
      final inner = _toRad(i * 45.0 + 22.5 - 90);
      final op =
          Offset(c.dx + r * math.cos(outer), c.dy + r * math.sin(outer));
      final ip = Offset(c.dx + r * 0.42 * math.cos(inner),
          c.dy + r * 0.42 * math.sin(inner));
      if (i == 0) {
        path.moveTo(op.dx, op.dy);
      } else {
        path.lineTo(op.dx, op.dy);
      }
      path.lineTo(ip.dx, ip.dy);
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter old) =>
      old.needleAngle != needleAngle ||
      old.isAligned != isAligned ||
      old.alignmentError != alignmentError ||
      old.pulse != pulse;
}
