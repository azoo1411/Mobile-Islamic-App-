import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  static const List<_QuickItem> _items = [
    _QuickItem(
        label: 'القرآن الكريم',
        icon: Icons.menu_book,
        color: Color(0xFF2D6A4F),
        route: '/quran'),
    _QuickItem(
        label: 'أوقات الصلاة',
        icon: Icons.access_time,
        color: Color(0xFF3A86FF),
        route: '/prayer'),
    _QuickItem(
        label: 'اتجاه القبلة',
        icon: Icons.explore,
        color: Color(0xFFD4AF37),
        route: '/qibla'),
    _QuickItem(
        label: 'الأذكار',
        icon: Icons.favorite,
        color: Color(0xFFE07A5F),
        route: '/hadith'),
    _QuickItem(
        label: 'القصائد',
        icon: Icons.library_books,
        color: Color(0xFF9B5DE5),
        route: '/poetry'),
    _QuickItem(
        label: 'البحث',
        icon: Icons.search,
        color: Color(0xFF00B4D8),
        route: '/quran/search'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _items.map((item) => _buildItem(context, item)).toList(),
    );
  }

  Widget _buildItem(BuildContext context, _QuickItem item) {
    return GestureDetector(
      onTap: () => context.push(item.route),
      child: Container(
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: item.color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: item.color, size: 28),
            const SizedBox(height: 8),
            Text(
              item.label,
              style: AppTypography.caption.copyWith(
                color: item.color,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickItem {
  final String label;
  final IconData icon;
  final Color color;
  final String route;

  const _QuickItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
  });
}
