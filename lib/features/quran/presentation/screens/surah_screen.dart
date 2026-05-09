import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';
import '../../../../database/app_database.dart';
import '../providers/quran_provider.dart';
import '../providers/tafsir_provider.dart';
import '../widgets/ayah_card.dart';
import '../widgets/audio_player_bar.dart';
import '../widgets/tafsir_sheet.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: data.ayahs.length,
      itemBuilder: (context, index) {
        final ayah = data.ayahs[index];
        return _TafsirAyahTile(ayah: ayah);
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

// ─── Tafsir tab tile ──────────────────────────────────────────────────────────

class _TafsirAyahTile extends ConsumerStatefulWidget {
  final Ayah ayah;
  const _TafsirAyahTile({required this.ayah});

  @override
  ConsumerState<_TafsirAyahTile> createState() => _TafsirAyahTileState();
}

class _TafsirAyahTileState extends ConsumerState<_TafsirAyahTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ayah = widget.ayah;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ayah text
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: _expanded
                  ? AppColors.primary.withOpacity(0.07)
                  : AppColors.primary.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primary
                    .withOpacity(_expanded ? 0.25 : 0.08),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    ayah.textUthmani,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.justify,
                    style: AppTypography.quranAyah.copyWith(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // Tafsir content (expanded)
        if (_expanded) _TafsirContent(ayah: ayah),

        const SizedBox(height: 10),
      ],
    );
  }
}

class _TafsirContent extends ConsumerWidget {
  final Ayah ayah;
  const _TafsirContent({required this.ayah});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tafsir =
        ref.watch(tafsirProvider((ayah.surahNumber, ayah.ayahNumber)));

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: tafsir.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(
                color: AppColors.primary, strokeWidth: 2),
          ),
        ),
        error: (e, _) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () =>
                  ref.invalidate(tafsirProvider((ayah.surahNumber, ayah.ayahNumber))),
              child: const Text('إعادة المحاولة',
                  style: TextStyle(
                      fontFamily: 'NotoNaskhArabic', color: AppColors.primary)),
            ),
            Text(
              e.toString().replaceFirst('Exception: ', ''),
              style: const TextStyle(
                  fontFamily: 'NotoNaskhArabic',
                  fontSize: 13,
                  color: AppColors.textSecondary),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        data: (text) => Text(
          text.isEmpty ? 'التفسير غير متوفر' : text,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.justify,
          style: const TextStyle(
            fontFamily: 'NotoNaskhArabic',
            fontSize: 15,
            height: 1.9,
            color: Color(0xFF2C2416),
          ),
        ),
      ),
    );
  }
}
