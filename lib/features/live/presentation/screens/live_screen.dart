import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final WebViewController _makkahController;
  late final WebViewController _madinahController;

  bool _makkahLoading = true;
  bool _madinahLoading = true;

  static const _makkahUrl = 'https://aloula.sba.sa/live/quran';
  static const _madinahUrl = 'https://aloula.sba.sa/live/sunna';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _makkahController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          _injectHideUI(_makkahController);
          if (mounted) setState(() => _makkahLoading = false);
        },
      ))
      ..loadRequest(Uri.parse(_makkahUrl));

    _madinahController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 '
        '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          _injectHideUI(_madinahController);
          if (mounted) setState(() => _madinahLoading = false);
        },
      ))
      ..loadRequest(Uri.parse(_madinahUrl));
  }

  void _injectHideUI(WebViewController controller) {
    controller.runJavaScript(r"""
(function() {
  var style = document.createElement('style');
  style.innerHTML = `
    /* Hide site header / nav bar */
    header, nav, .header, .navbar, .nav-bar,
    [class*="header"], [class*="Header"],
    [class*="navbar"], [class*="NavBar"],
    /* Hide search bars */
    [class*="search"], [class*="Search"],
    input[type="search"], input[type="text"],
    /* Hide channel grid / channel list / carousel */
    [class*="channel"], [class*="Channel"],
    [class*="playlist"], [class*="Playlist"],
    [class*="carousel"], [class*="Carousel"],
    [class*="grid"], [class*="Grid"],
    [class*="thumbnail"], [class*="Thumbnail"],
    [class*="card-list"], [class*="CardList"],
    [class*="related"], [class*="Related"],
    [class*="sidebar"], [class*="Sidebar"],
    [class*="recommendation"], [class*="Recommendation"],
    /* Hide footer */
    footer, .footer, [class*="footer"], [class*="Footer"],
    /* Hide cookie banners / modals */
    [class*="cookie"], [class*="Cookie"],
    [class*="modal"], [class*="Modal"],
    [class*="overlay"]:not([class*="video"]):not([class*="player"]) {
      display: none !important;
      visibility: hidden !important;
      height: 0 !important;
      overflow: hidden !important;
    }
    /* Make video player fill screen */
    body { overflow: hidden !important; background: #000 !important; }
    video { width: 100% !important; }
  `;
  document.head.appendChild(style);
})();
""");
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'البث المباشر',
            style: TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            indicatorColor: const Color(0xFFD4AF37),
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            tabs: const [
              Tab(icon: Icon(Icons.mosque, size: 20), text: 'الحرم المكي'),
              Tab(icon: Icon(Icons.star_outline, size: 20), text: 'المسجد النبوي'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTab(
              controller: _makkahController,
              isLoading: _makkahLoading,
              title: 'الحرم المكي',
              subtitle: 'قناة القرآن الكريم',
              color: const Color(0xFF1A6B3A),
            ),
            _buildTab(
              controller: _madinahController,
              isLoading: _madinahLoading,
              title: 'المسجد النبوي',
              subtitle: 'قناة السنة النبوية',
              color: const Color(0xFF2C4A8E),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required WebViewController controller,
    required bool isLoading,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      children: [
        // Live banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: color,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4444),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'بث مباشر',
                style: TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'NotoNaskhArabic',
                      fontSize: 11,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // WebView
        Expanded(
          child: Stack(
            children: [
              WebViewWidget(controller: controller),
              if (isLoading)
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mosque, color: color, size: 56),
                        const SizedBox(height: 20),
                        Text(
                          title,
                          style: AppTypography.heading3.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: AppTypography.bodySmall.copyWith(color: Colors.white54),
                        ),
                        const SizedBox(height: 32),
                        const CircularProgressIndicator(
                          color: Color(0xFFD4AF37),
                          strokeWidth: 2.5,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'جاري تحميل البث المباشر...',
                          style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 13,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
