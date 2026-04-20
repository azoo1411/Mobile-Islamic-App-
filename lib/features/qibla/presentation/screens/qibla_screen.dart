import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';

const double _kaabaLat = 21.4225;
const double _kaabaLon = 39.8262;

double _toRad(double deg) => deg * math.pi / 180;
double _toDeg(double rad) => rad * 180 / math.pi;

double _qiblaAngle(double userLat, double userLon) {
  final dLon = _toRad(_kaabaLon - userLon);
  final lat1 = _toRad(userLat);
  final lat2 = _toRad(_kaabaLat);
  final y = math.sin(dLon) * math.cos(lat2);
  final x =
      math.cos(lat1) * math.sin(lat2) - math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
  return (_toDeg(math.atan2(y, x)) + 360) % 360;
}

class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});

  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen> {
  bool _permissionGranted = false;
  double? _qiblaAngleDeg;
  double _compassHeading = 0;

  @override
  void initState() {
    super.initState();
    _init();
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
        setState(() => _qiblaAngleDeg = _qiblaAngle(pos.latitude, pos.longitude));
      }
    } catch (_) {}

    magnetometerEventStream().listen((event) {
      if (!mounted) return;
      final heading = (_toDeg(math.atan2(event.y, event.x)) + 360) % 360;
      setState(() => _compassHeading = heading);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اتجاه القبلة'),
          leading: const BackButton(),
        ),
        body: _permissionGranted ? _buildContent() : _buildPermissionRequired(),
      ),
    );
  }

  Widget _buildContent() {
    if (_qiblaAngleDeg == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    final needleAngle = _toRad(_qiblaAngleDeg! - _compassHeading);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildCompass(needleAngle),
          const SizedBox(height: 32),
          _buildAngleInfo(),
          const SizedBox(height: 24),
          _buildKaabaCard(),
        ],
      ),
    );
  }

  Widget _buildCompass(double needleAngle) {
    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.divider, width: 2),
                color: AppColors.primary.withOpacity(0.04),
              ),
            ),
            // Cardinal directions
            ..._cardinalLabels(),
            // Qibla needle
            Transform.rotate(
              angle: needleAngle,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 6,
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.gold, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ),
                  const Text('🕋', style: TextStyle(fontSize: 28)),
                  Container(width: 6, height: 60, color: Colors.transparent),
                ],
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _cardinalLabels() {
    final labels = [('N', Alignment.topCenter), ('S', Alignment.bottomCenter),
        ('E', Alignment.centerRight), ('W', Alignment.centerLeft)];
    return labels
        .map((l) => Align(
              alignment: l.$2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(l.$1,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 13)),
              ),
            ))
        .toList();
  }

  Widget _buildAngleInfo() {
    final angle = _qiblaAngleDeg!.round();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '${ArabicUtils.toArabicNumerals(angle)}°',
                style: AppTypography.prayerTime.copyWith(fontSize: 28),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text('الزاوية من الشمال', style: AppTypography.caption),
      ],
    );
  }

  Widget _buildKaabaCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('الكعبة المشرفة', style: AppTypography.heading3),
                  const SizedBox(width: 8),
                  const Text('🕋', style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'اتجه نحو الإبرة الذهبية للصلاة باتجاه القبلة',
                style: AppTypography.bodySmall,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionRequired() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🕋', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 24),
            Text(
              'يتطلب عرض اتجاه القبلة الإذن بالوصول إلى موقعك',
              style: AppTypography.body,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _init,
              child: const Text('السماح بالوصول'),
            ),
          ],
        ),
      ),
    );
  }
}
