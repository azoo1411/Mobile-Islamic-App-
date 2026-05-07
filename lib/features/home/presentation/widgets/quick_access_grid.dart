import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  static const List<_QuickItem> _items = [
    _QuickItem(
      label: 'القرآن الكريم',
      imagePath: 'assets/images/quick_access/quran.png',
      route: '/quran',
    ),
    _QuickItem(
      label: 'مواقيت الصلاة',
      imagePath: 'assets/images/quick_access/prayer.png',
      route: '/prayer',
    ),
    _QuickItem(
      label: 'اتجاه القبلة',
      imagePath: 'assets/images/quick_access/qibla.png',
      route: '/qibla',
    ),
    _QuickItem(
      label: 'القصائد',
      imagePath: 'assets/images/quick_access/poetry.png',
      route: '/poetry',
    ),
    _QuickItem(
      label: 'المركز المرئي',
      imagePath: 'assets/images/quick_access/live.png',
      route: '/live',
    ),
    _QuickItem(
      label: 'الحج والعمرة',
      imagePath: 'assets/images/quick_access/hajj.png',
      route: '/hajj',
    ),
    _QuickItem(
      label: 'الأذكار',
      imagePath: 'assets/images/quick_access/adhkar.png',
      route: '/adhkar',
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
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 8, 6, 2),
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.wb_sunny_outlined,
                      color: Color(0xFFD4AF37),
                      size: 40,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 8),
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontFamily: 'NotoNaskhArabic',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2C2416),
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
  final String imagePath;
  final String route;

  const _QuickItem({
    required this.label,
    required this.imagePath,
    required this.route,
  });
}
