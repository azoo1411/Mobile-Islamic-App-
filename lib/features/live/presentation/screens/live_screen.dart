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
  // ── Inject hide CSS ──────────────────────────────────────────────────────
  var style = document.createElement('style');
  style.id = '__hide_ui__';
  style.innerHTML = `
    /* Hide everything except the video player wrapper */
    header, nav, footer,
    [class*="header" i], [class*="navbar" i], [class*="nav-bar" i],
    [class*="search" i],
    [class*="channel" i], [class*="playlist" i],
    [class*="carousel" i], [class*="slider" i],
    [class*="program" i], [class*="schedule" i],
    [class*="grid" i]:not([class*="video" i]):not([class*="player" i]),
    [class*="thumbnail" i], [class*="thumb" i],
    [class*="card-list" i], [class*="related" i],
    [class*="sidebar" i], [class*="recommend" i],
    [class*="epg" i], [class*="now-playing" i],
    [class*="footer" i], [class*="cookie" i],
    [class*="modal" i], [class*="banner" i],
    [class*="social" i], [class*="share" i],
    [class*="bottom" i]:not([class*="video" i]):not([class*="player" i]),
    [class*="strip" i], [class*="row" i]:not([class*="video" i]):not([class*="player" i]) {
      display: none !important;
      height: 0 !important;
      overflow: hidden !important;
      pointer-events: none !important;
    }
    html, body {
      overflow: hidden !important;
      background: #000 !important;
      margin: 0 !important;
      padding: 0 !important;
    }
    video {
      width: 100vw !important;
      max-width: 100vw !important;
    }
  `;
  if (!document.getElementById('__hide_ui__')) {
    document.head.appendChild(style);
  }

  // ── Aggressively hide channel rows by scanning DOM ────────────────────────
  function hideChannelRows() {
    // Target any horizontal scrollable list or row that contains channel images
    document.querySelectorAll('ul, ol, div').forEach(function(el) {
      var children = el.children;
      if (children.length >= 3) {
        // Check if this looks like a channel row (multiple image children in a row)
        var hasImages = el.querySelectorAll('img').length >= 2;
        var isHorizontal = getComputedStyle(el).flexDirection === 'row'
          || getComputedStyle(el).display === 'flex'
          || getComputedStyle(el).overflowX === 'auto'
          || getComputedStyle(el).overflowX === 'scroll';
        var rect = el.getBoundingClientRect();
        var isAtBottom = rect.top > window.innerHeight * 0.55;

        if (hasImages && (isHorizontal || isAtBottom)) {
          el.style.setProperty('display', 'none', 'important');
          el.style.setProperty('height', '0', 'important');
          // Also hide parent if it becomes empty-looking
          if (el.parentElement) {
            var p = el.parentElement;
            p.style.setProperty('max-height', p.getBoundingClientRect().height - rect.height + 'px', 'important');
          }
        }
      }
    });
  }

  // Run immediately and after short delays for dynamic content
  hideChannelRows();
  setTimeout(hideChannelRows, 800);
  setTimeout(hideChannelRows, 2000);

  // Watch for DOM changes and re-hide
  if (window.__mutObs__) window.__mutObs__.disconnect();
  window.__mutObs__ = new MutationObserver(function() { hideChannelRows(); });
  window.__mutObs__.observe(document.body, { childList: true, subtree: true });
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
