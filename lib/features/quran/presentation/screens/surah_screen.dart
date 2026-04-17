import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../providers/quran_provider.dart';
import '../widgets/ayah_card.dart';
import '../widgets/audio_player_bar.dart';

class SurahScreen extends ConsumerStatefulWidget {
  final int surahNumber;
  final int startAyah;

  const SurahScreen({
    super.key,
    required this.surahNumber,
    this.startAyah = 1,
  });

  @override
  ConsumerState<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends ConsumerState<SurahScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _fontSize = 22;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahAsync =
        ref.watch(surahDetailsProvider(widget.surahNumber));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: surahAsync.when(
            data: (data) =>
                Text(data.surah.nameArabic, style: AppTypography.surahName.copyWith(color: Colors.white)),
            loading: () => const Text('...'),
            error: (_, __) => const Text('خطأ'),
          ),
          leading: const BackButton(),
          actions: [
            IconButton(
              icon: const Icon(Icons.text_fields),
              onPressed: _showFontSizeDialog,
              tooltip: 'حجم الخط',
            ),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {},
              tooltip: 'إشارة مرجعية',
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.gold,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(
              fontFamily: 'NotoNaskhArabic',
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            tabs: const [Tab(text: 'التلاوة'), Tab(text: 'التفسير')],
          ),
        ),
        body: surahAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (data) => Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRecitationTab(data),
                    _buildTafseerTab(data),
                  ],
                ),
              ),
              const AudioPlayerBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecitationTab(SurahDetailsData data) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      itemCount: data.ayahs.length + 1, // +1 for basmala header
      itemBuilder: (context, index) {
        if (index == 0) return _buildSurahHeader(data);
        final ayah = data.ayahs[index - 1];
        return AyahCard(ayah: ayah, fontSize: _fontSize);
      },
    );
  }

  Widget _buildSurahHeader(SurahDetailsData data) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text(
                data.surah.nameArabic,
                style: AppTypography.surahName.copyWith(fontSize: 28),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: 4),
              Text(
                '${data.surah.revelationType == 'meccan' ? 'مكية' : 'مدنية'} · ${ArabicUtils.toArabicNumerals(data.surah.ayahCount)} آية',
                style: AppTypography.bodySmall,
              ),
            ],
          ),
        ),
        if (data.surah.number != 1 && data.surah.number != 9)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              style: AppTypography.basmala,
              textDirection: TextDirection.rtl,
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildTafseerTab(SurahDetailsData data) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: data.ayahs.length,
      itemBuilder: (context, index) {
        final ayah = data.ayahs[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                ayah.textUthmani,
                style: AppTypography.quranAyah.copyWith(fontSize: 18),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'التفسير غير متاح بدون اتصال',
              style: AppTypography.bodySmall,
              textDirection: TextDirection.rtl,
            ),
            const Divider(height: 24),
          ],
        );
      },
    );
  }

  void _showFontSizeDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('حجم الخط', style: AppTypography.heading3),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (ctx, setModalState) => Slider(
                  value: _fontSize,
                  min: 16,
                  max: 36,
                  divisions: 10,
                  activeColor: AppColors.primary,
                  onChanged: (v) {
                    setModalState(() => _fontSize = v);
                    setState(() => _fontSize = v);
                  },
                ),
              ),
              Center(
                child: Text(
                  'نموذج: بِسْمِ اللَّهِ',
                  style: TextStyle(
                    fontFamily: 'AmiriQuran',
                    fontSize: _fontSize,
                    color: AppColors.textQuran,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
