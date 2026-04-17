import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';

class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});

  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen> {
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.location.request();
    if (mounted) {
      setState(() => _permissionGranted = status.isGranted);
    }
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
        body: _permissionGranted
            ? _buildQiblaCompass()
            : _buildPermissionRequired(),
      ),
    );
  }

  Widget _buildQiblaCompass() {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }

        final qiblah = snapshot.data!;
        final direction = qiblah.direction;
        final qiblaOffset = qiblah.offset;

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),
              _buildCompassWidget(direction, qiblaOffset),
              const SizedBox(height: 32),
              _buildDirectionInfo(qiblaOffset),
              const SizedBox(height: 24),
              _buildKaabaInfo(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompassWidget(double direction, double qiblaOffset) {
    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.divider, width: 2),
              ),
            ),
            // Compass rose (rotates with device)
            Transform.rotate(
              angle: (direction * (math.pi / 180) * -1),
              child: Image.asset(
                'assets/images/compass_rose.png',
                errorBuilder: (_, __, ___) =>
                    _buildFallbackCompassRose(direction),
              ),
            ),
            // Qibla needle (stays pointing to Qibla)
            Transform.rotate(
              angle: (qiblaOffset * (math.pi / 180) * -1),
              child: Column(
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
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(3)),
                    ),
                  ),
                  const Text('🕋', style: TextStyle(fontSize: 28)),
                  Container(
                    width: 6,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
            // Center dot
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

  Widget _buildFallbackCompassRose(double direction) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withOpacity(0.05),
      ),
      child: const Center(
        child: Text(
          'N\nالشمال',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'NotoNaskhArabic',
            fontSize: 14,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildDirectionInfo(double qiblaOffset) {
    final angle = qiblaOffset.abs();
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
                '${ArabicUtils.toArabicNumerals(angle.round())}°',
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

  Widget _buildKaabaInfo() {
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
              onPressed: _checkPermission,
              child: const Text('السماح بالوصول'),
            ),
          ],
        ),
      ),
    );
  }
}
