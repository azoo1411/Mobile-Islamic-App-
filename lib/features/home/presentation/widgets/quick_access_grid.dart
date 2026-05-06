import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  static const List<_QuickItem> _items = [
    _QuickItem(
      label: 'القرآن الكريم',
      icon: Icons.menu_book_rounded,
      color: Color(0xFF2D6A4F),
      route: '/quran',
    ),
    _QuickItem(
      label: 'أوقات الصلاة',
      icon: Icons.access_time_rounded,
      color: Color(0xFF3A86FF),
      route: '/prayer',
    ),
    _QuickItem(
      label: 'اتجاه القبلة',
      icon: Icons.explore_rounded,
      color: Color(0xFFD4AF37),
      route: '/qibla',
    ),
    _QuickItem(
      label: 'القصائد',
      icon: Icons.draw_rounded,
      color: Color(0xFFB07340),
      route: '/poetry',
    ),
    _QuickItem(
      label: 'المركز المرئي',
      icon: Icons.play_circle_rounded,
      color: Color(0xFFE53935),
      route: '/live',
    ),
    _QuickItem(
      label: 'الحج والعمرة',
      icon: Icons.mosque_rounded,
      color: Color(0xFF8B7035),
      route: '/hajj',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.95,
      children: _items.map((item) => _QuickCard(item: item)).toList(),
    );
  }
}

class _QuickCard extends StatefulWidget {
  final _QuickItem item;
  const _QuickCard({required this.item});

  @override
  State<_QuickCard> createState() => _QuickCardState();
}

class _QuickCardState extends State<_QuickCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        context.push(item.route);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFBF8F2),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8E0D0), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon circle
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: item.color.withOpacity(0.2),
                    width: 1.2,
                  ),
                ),
                child: Icon(item.icon, color: item.color, size: 26),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C2416),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
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
