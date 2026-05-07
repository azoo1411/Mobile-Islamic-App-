import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  static const List<_NavItem> _items = [
    _NavItem(path: '/home', icon: Icons.home_outlined, activeIcon: Icons.home, label: 'الرئيسية'),
    _NavItem(path: '/quran', icon: Icons.menu_book_outlined, activeIcon: Icons.menu_book, label: 'القرآن'),
    _NavItem(path: '/adhkar', icon: Icons.wb_sunny_outlined, activeIcon: Icons.wb_sunny, label: 'الأذكار'),
    _NavItem(path: '/prayer', icon: Icons.access_time_outlined, activeIcon: Icons.access_time, label: 'الصلاة'),
    _NavItem(path: '/poetry', icon: Icons.library_books_outlined, activeIcon: Icons.library_books, label: 'المكتبة'),
  ];

  int _currentIndex(String location) {
    for (int i = 0; i < _items.length; i++) {
      if (location.startsWith(_items[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _currentIndex(location);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (i) => context.go(_items[i].path),
          items: _items
              .map((item) => BottomNavigationBarItem(
                    icon: Icon(item.icon),
                    activeIcon: Icon(item.activeIcon),
                    label: item.label,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _NavItem {
  final String path;
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.path,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
