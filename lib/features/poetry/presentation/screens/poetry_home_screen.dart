import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class PoetryHomeScreen extends StatelessWidget {
  const PoetryHomeScreen({super.key});

  static const List<Color> _categoryColors = [
    Color(0xFF1B4332),
    Color(0xFF9B5DE5),
    Color(0xFFD4AF37),
    Color(0xFF2D6A4F),
    Color(0xFF3A86FF),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المكتبة الشعرية'),
          actions: [
            IconButton(
                icon: const Icon(Icons.search), onPressed: () {}),
          ],
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
                  childAspectRatio: 1.1,
                ),
                itemCount: AppConstants.poetryCategories.length,
                itemBuilder: (context, index) {
                  final cat = AppConstants.poetryCategories[index];
                  return _buildCategoryCard(
                    context,
                    cat,
                    _categoryColors[index % _categoryColors.length],
                  );
                },
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
          Text('الشعر العربي الإسلامي', style: AppTypography.heading2),
          const SizedBox(height: 4),
          Text(
            'مجموعة مختارة من القصائد العربية المصنفة',
            style: AppTypography.bodySmall,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, Map<String, String> cat, Color color) {
    return GestureDetector(
      onTap: () => context.push('/poetry/${cat['id']}'),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withOpacity(0.7)],
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
              Text(
                cat['icon'] ?? '📖',
                style: const TextStyle(fontSize: 32),
              ),
              Text(
                cat['name']!,
                style: const TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
