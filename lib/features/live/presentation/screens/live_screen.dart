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

  // YouTube channel IDs for 24/7 live streams
  // قناة القرآن الكريم — الحرم المكي
  static const _makkahChannelId = 'UCpDMzMbLoSHOdWqHXlp2fDA';
  // قناة السنة النبوية — المسجد النبوي
  static const _madinahChannelId = 'UC0EtHHiB0Z2SSwRVVsF5BqA';

  String _embedHtml(String channelId) => '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { background: #000; width: 100vw; height: 100vh; overflow: hidden; }
  iframe { width: 100%; height: 100%; border: none; }
</style>
</head>
<body>
<iframe
  src="https://www.youtube.com/embed/live_stream?channel=$channelId&autoplay=1&playsinline=1"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
  allowfullscreen>
</iframe>
</body>
</html>
''';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _makkahController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          if (mounted) setState(() => _makkahLoading = false);
        },
      ))
      ..loadHtmlString(_embedHtml(_makkahChannelId));

    _madinahController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) {
          if (mounted) setState(() => _madinahLoading = false);
        },
      ))
      ..loadHtmlString(_embedHtml(_madinahChannelId));
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
              Tab(
                icon: Icon(Icons.mosque, size: 20),
                text: 'الحرم المكي',
              ),
              Tab(
                icon: Icon(Icons.star_outline, size: 20),
                text: 'المسجد النبوي',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildStreamTab(
              controller: _makkahController,
              isLoading: _makkahLoading,
              title: 'الحرم المكي',
              subtitle: 'قناة القرآن الكريم',
              color: const Color(0xFF1A6B3A),
            ),
            _buildStreamTab(
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

  Widget _buildStreamTab({
    required WebViewController controller,
    required bool isLoading,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      children: [
        // Live indicator banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
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
              const SizedBox(width: 8),
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

        // WebView player
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
                        Icon(
                          Icons.mosque,
                          color: color,
                          size: 48,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          title,
                          style: AppTypography.heading3
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: AppTypography.bodySmall
                              .copyWith(color: Colors.white54),
                        ),
                        const SizedBox(height: 32),
                        const CircularProgressIndicator(
                          color: Color(0xFFD4AF37),
                          strokeWidth: 2.5,
                        ),
                        const SizedBox(height: 16),
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
