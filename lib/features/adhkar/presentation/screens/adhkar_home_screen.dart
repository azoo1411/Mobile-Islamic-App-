import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class AdhkarHomeScreen extends StatelessWidget {
  const AdhkarHomeScreen({super.key});

  static const _categories = [
    _AdhkarCategory(
      id: 'morning',
      name: 'أذكار الصباح',
      icon: Icons.wb_sunny_outlined,
      color: Color(0xFFF9A825),
      count: 9,
    ),
    _AdhkarCategory(
      id: 'evening',
      name: 'أذكار المساء',
      icon: Icons.nightlight_outlined,
      color: Color(0xFF3A86FF),
      count: 9,
    ),
    _AdhkarCategory(
      id: 'sleep',
      name: 'أذكار النوم',
      icon: Icons.hotel_outlined,
      color: Color(0xFF6B48FF),
      count: 6,
    ),
    _AdhkarCategory(
      id: 'prayer',
      name: 'أذكار بعد الصلاة',
      icon: Icons.mosque_outlined,
      color: Color(0xFF2D6A4F),
      count: 7,
    ),
    _AdhkarCategory(
      id: 'tasbih',
      name: 'تسبيح وتحميد',
      icon: Icons.grain,
      color: Color(0xFFD4AF37),
      count: 5,
    ),
    _AdhkarCategory(
      id: 'duaa',
      name: 'أدعية مختارة',
      icon: Icons.volunteer_activism_outlined,
      color: Color(0xFFE07A5F),
      count: 8,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الأذكار والأدعية'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildHeader(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) =>
                    _buildCategoryCard(context, _categories[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      color: AppColors.primary.withOpacity(0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('حصن المسلم', style: AppTypography.heading2),
          const SizedBox(height: 4),
          Text(
            'أذكار وأدعية من القرآن الكريم والسنة النبوية',
            style: AppTypography.bodySmall,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, _AdhkarCategory cat) {
    return GestureDetector(
      onTap: () => context.push('/adhkar/\${cat.id}'),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cat.color, cat.color.withOpacity(0.75)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(cat.icon, color: Colors.white, size: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    cat.name,
                    style: const TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  Text(
                    '\${cat.count} ذكر',
                    style: const TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdhkarCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int count;
  const _AdhkarCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.count,
  });
}
