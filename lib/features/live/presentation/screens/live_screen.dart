import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/theme/app_colors.dart';

// ── YouTube channel IDs for the two holy mosques ─────────────────────────────
// قناة القرآن الكريم (Makkah live) — SBA official YouTube channel
const _makkahChannelId = 'UCbeKNaONTCgQjWF1mGJMfbw';
// قناة السنة النبوية (Madinah live) — SBA official YouTube channel
const _madinahChannelId = 'UC4bCMGbRMeVGR82V4DTXPWQ';

const _makkahYouTubeUrl  = 'https://www.youtube.com/channel/$_makkahChannelId/live';
const _madinahYouTubeUrl = 'https://www.youtube.com/channel/$_madinahChannelId/live';

// ── Builds a self-contained HTML page with a full-screen YouTube embed ────────
String _buildEmbedHtml(String channelId) => '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    html, body {
      width: 100%; height: 100%;
      background: #000;
      overflow: hidden;
    }
    iframe {
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      border: none;
    }
  </style>
</head>
<body>
  <iframe
    src="https://www.youtube.com/embed/live_stream?channel=$channelId&autoplay=1&controls=1&modestbranding=1&rel=0&playsinline=1"
    allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
    allowfullscreen>
  </iframe>
</body>
</html>
''';

// ─────────────────────────────────────────────────────────────────────────────

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

  _TabState _makkahState = _TabState.loading;
  _TabState _madinahState = _TabState.loading;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _makkahController  = _buildController(_makkahChannelId,  (s) => setState(() => _makkahState  = s));
    _madinahController = _buildController(_madinahChannelId, (s) => setState(() => _madinahState = s));
  }

  WebViewController _buildController(
    String channelId,
    void Function(_TabState) onState,
  ) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => onState(_TabState.loading),
        onPageFinished: (_) => onState(_TabState.loaded),
        onHttpError: (error) {
          if (error.response?.statusCode != null &&
              (error.response?.statusCode ?? 0) >= 400) {
            onState(_TabState.error);
          }
        },
        onWebResourceError: (_) => onState(_TabState.error),
      ))
      ..loadHtmlString(_buildEmbedHtml(channelId));
  }

  void _reload(WebViewController ctrl, String channelId, void Function(_TabState) onState) {
    onState(_TabState.loading);
    ctrl.loadHtmlString(_buildEmbedHtml(channelId));
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
            _LiveTab(
              controller: _makkahController,
              state: _makkahState,
              title: 'الحرم المكي',
              subtitle: 'قناة القرآن الكريم',
              accentColor: const Color(0xFF1A6B3A),
              youTubeUrl: _makkahYouTubeUrl,
              onRetry: () => _reload(
                _makkahController,
                _makkahChannelId,
                (s) => setState(() => _makkahState = s),
              ),
            ),
            _LiveTab(
              controller: _madinahController,
              state: _madinahState,
              title: 'المسجد النبوي',
              subtitle: 'قناة السنة النبوية',
              accentColor: const Color(0xFF2C4A8E),
              youTubeUrl: _madinahYouTubeUrl,
              onRetry: () => _reload(
                _madinahController,
                _madinahChannelId,
                (s) => setState(() => _madinahState = s),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab state ─────────────────────────────────────────────────────────────────

enum _TabState { loading, loaded, error }

// ── Individual tab widget ─────────────────────────────────────────────────────

class _LiveTab extends StatelessWidget {
  final WebViewController controller;
  final _TabState state;
  final String title;
  final String subtitle;
  final Color accentColor;
  final String youTubeUrl;
  final VoidCallback onRetry;

  const _LiveTab({
    required this.controller,
    required this.state,
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.youTubeUrl,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Live badge banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: accentColor,
          child: Row(
            children: [
              _PulseDot(color: state == _TabState.error
                  ? Colors.orange
                  : const Color(0xFFFF4444)),
              const SizedBox(width: 6),
              Text(
                state == _TabState.error ? 'تعذّر الاتصال' : 'بث مباشر',
                style: const TextStyle(
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
                  Text(title,
                      style: const TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      )),
                  Text(subtitle,
                      style: const TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 11,
                        color: Colors.white60,
                      )),
                ],
              ),
            ],
          ),
        ),

        // Content area
        Expanded(
          child: Stack(
            children: [
              // WebView always rendered (hidden behind overlays when needed)
              WebViewWidget(controller: controller),

              // Loading overlay
              if (state == _TabState.loading)
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mosque, color: accentColor, size: 56),
                        const SizedBox(height: 20),
                        Text(title,
                            style: const TextStyle(
                              fontFamily: 'NotoNaskhArabic',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            )),
                        const SizedBox(height: 6),
                        Text(subtitle,
                            style: const TextStyle(
                              fontFamily: 'NotoNaskhArabic',
                              fontSize: 13,
                              color: Colors.white54,
                            )),
                        const SizedBox(height: 32),
                        const CircularProgressIndicator(
                          color: Color(0xFFD4AF37),
                          strokeWidth: 2.5,
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'جاري تحميل البث...',
                          style: TextStyle(
                            fontFamily: 'NotoNaskhArabic',
                            fontSize: 13,
                            color: Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Error overlay
              if (state == _TabState.error)
                Container(
                  color: const Color(0xFF0A0A0A),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.wifi_off_rounded,
                              color: Colors.white24, size: 64),
                          const SizedBox(height: 20),
                          Text(title,
                              style: const TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )),
                          const SizedBox(height: 10),
                          const Text(
                            'تعذّر تحميل البث المباشر\nتحقق من الاتصال بالإنترنت',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'NotoNaskhArabic',
                              fontSize: 13,
                              color: Colors.white38,
                              height: 1.7,
                            ),
                          ),
                          const SizedBox(height: 28),
                          // Retry button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: onRetry,
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: const Text(
                                'إعادة المحاولة',
                                style: TextStyle(
                                  fontFamily: 'NotoNaskhArabic',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Open in YouTube button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => launchUrl(
                                Uri.parse(youTubeUrl),
                                mode: LaunchMode.externalApplication,
                              ),
                              icon: const Icon(Icons.open_in_new_rounded, size: 16),
                              label: const Text(
                                'فتح في يوتيوب',
                                style: TextStyle(
                                  fontFamily: 'NotoNaskhArabic',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white54,
                                side: const BorderSide(color: Colors.white12),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

// ── Animated pulsing dot for live indicator ───────────────────────────────────

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(_anim);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
