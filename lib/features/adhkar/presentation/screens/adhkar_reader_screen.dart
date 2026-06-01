import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class AdhkarReaderScreen extends StatelessWidget {
  final String categoryId;
  const AdhkarReaderScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final data = _data[categoryId] ?? [];
    final title = _titles[categoryId] ?? 'أذكار';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: data.isEmpty
            ? const Center(
                child: Text('لا توجد أذكار', style: AppTypography.body))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: data.length,
                itemBuilder: (context, index) =>
                    _AdhkarCard(item: data[index], index: index + 1),
              ),
      ),
    );
  }

  static const _titles = {
    'morning': 'أذكار الصباح',
    'evening': 'أذكار المساء',
    'sleep': 'أذكار النوم',
    'prayer': 'أذكار بعد الصلاة',
    'tasbih': 'تسبيح وتحميد',
    'duaa': 'أدعية مختارة',
  };

  static const _data = <String, List<Map<String, dynamic>>>{
    'morning': [
      {
        'text': 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ\nاللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَّهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَن ذَا الَّذِي يَشْفَعُ عِندَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِّنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
        'source': 'آية الكرسي — البقرة ٢٥٥',
        'count': 1,
      },
      {
        'text': 'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        'source': 'سورة الإخلاص',
        'count': 3,
      },
      {
        'text': 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِن شَرِّ مَا خَلَقَ ۝ وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ',
        'source': 'سورة الفلق',
        'count': 3,
      },
      {
        'text': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ',
        'source': 'سورة الناس',
        'count': 3,
      },
      {
        'text': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
        'source': 'رواه مسلم',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ النُّشُورُ.',
        'source': 'رواه الترمذي',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ.',
        'source': 'سيد الاستغفار — رواه البخاري',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لَا إِلَهَ إِلَّا أَنْتَ.',
        'source': 'رواه أبو داود',
        'count': 3,
      },
      {
        'text': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي.',
        'source': 'رواه أبو داود وابن ماجه',
        'count': 1,
      },
    ],
    'evening': [
      {
        'text': 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ\nاللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ...',
        'source': 'آية الكرسي — البقرة ٢٥٥',
        'count': 1,
      },
      {
        'text': 'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        'source': 'سورة الإخلاص',
        'count': 3,
      },
      {
        'text': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
        'source': 'رواه مسلم',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ، وَإِلَيْكَ الْمَصِيرُ.',
        'source': 'رواه الترمذي',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي، فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ.',
        'source': 'سيد الاستغفار — رواه البخاري',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ إِنِّي أَمْسَيْتُ أُشْهِدُكَ، وَأُشْهِدُ حَمَلَةَ عَرْشِكَ، وَمَلَائِكَتَكَ، وَجَمِيعَ خَلْقِكَ، أَنَّكَ أَنْتَ اللَّهُ لَا إِلَهَ إِلَّا أَنْتَ وَحْدَكَ لَا شَرِيكَ لَكَ، وَأَنَّ مُحَمَّدًا عَبْدُكَ وَرَسُولُكَ.',
        'source': 'رواه أبو داود',
        'count': 4,
      },
      {
        'text': 'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ.',
        'source': 'رواه أبو داود والترمذي',
        'count': 3,
      },
      {
        'text': 'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالإِسْلامِ دِينًا، وَبِمُحَمَّدٍ ﷺ نَبِيًّا.',
        'source': 'رواه أبو داود والترمذي',
        'count': 3,
      },
      {
        'text': 'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ، أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ.',
        'source': 'رواه الحاكم',
        'count': 1,
      },
    ],
    'sleep': [
      {
        'text': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا.',
        'source': 'رواه البخاري',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ.',
        'source': 'رواه أبو داود والترمذي',
        'count': 3,
      },
      {
        'text': 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ.',
        'source': 'رواه البخاري ومسلم',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ أَسْلَمْتُ نَفْسِي إِلَيْكَ، وَفَوَّضْتُ أَمْرِي إِلَيْكَ، وَوَجَّهْتُ وَجْهِيَ إِلَيْكَ، وَأَلْجَأْتُ ظَهْرِي إِلَيْكَ، رَغْبَةً وَرَهْبَةً إِلَيْكَ، لَا مَلْجَأَ وَلَا مَنْجَا مِنْكَ إِلَّا إِلَيْكَ، آمَنْتُ بِكِتَابِكَ الَّذِي أَنْزَلْتَ، وَنَبِيِّكَ الَّذِي أَرْسَلْتَ.',
        'source': 'رواه البخاري ومسلم',
        'count': 1,
      },
      {
        'text': 'سُبْحَانَ اللَّهِ',
        'source': 'رواه البخاري ومسلم',
        'count': 33,
      },
      {
        'text': 'الْحَمْدُ لِلَّهِ',
        'source': 'رواه البخاري ومسلم',
        'count': 33,
      },
      {
        'text': 'اللَّهُ أَكْبَرُ',
        'source': 'رواه البخاري ومسلم',
        'count': 34,
      },
    ],
    'prayer': [
      {
        'text': 'أَسْتَغْفِرُ اللَّهَ',
        'source': 'رواه مسلم',
        'count': 3,
      },
      {
        'text': 'اللَّهُمَّ أَنْتَ السَّلَامُ وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالإِكْرَامِ.',
        'source': 'رواه مسلم',
        'count': 1,
      },
      {
        'text': 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
        'source': 'رواه البخاري ومسلم',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ لَا مَانِعَ لِمَا أَعْطَيْتَ، وَلَا مُعْطِيَ لِمَا مَنَعْتَ، وَلَا يَنْفَعُ ذَا الْجَدِّ مِنْكَ الْجَدُّ.',
        'source': 'رواه البخاري ومسلم',
        'count': 1,
      },
      {
        'text': 'سُبْحَانَ اللَّهِ',
        'source': 'رواه مسلم',
        'count': 33,
      },
      {
        'text': 'الْحَمْدُ لِلَّهِ',
        'source': 'رواه مسلم',
        'count': 33,
      },
      {
        'text': 'اللَّهُ أَكْبَرُ',
        'source': 'رواه مسلم',
        'count': 33,
      },
    ],
    'tasbih': [
      {
        'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        'source': 'رواه البخاري ومسلم',
        'count': 100,
      },
      {
        'text': 'سُبْحَانَ اللَّهِ الْعَظِيمِ',
        'source': 'رواه البخاري',
        'count': 100,
      },
      {
        'text': 'لَا إِلَهَ إِلَّا اللَّهُ',
        'source': 'رواه البخاري ومسلم',
        'count': 100,
      },
      {
        'text': 'اللَّهُ أَكْبَرُ كَبِيرًا، وَالْحَمْدُ لِلَّهِ كَثِيرًا، وَسُبْحَانَ اللَّهِ بُكْرَةً وَأَصِيلًا.',
        'source': 'رواه مسلم',
        'count': 1,
      },
      {
        'text': 'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',
        'source': 'رواه مسلم',
        'count': 1,
      },
    ],
    'duaa': [
      {
        'text': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ.',
        'source': 'سورة البقرة ٢٠١',
        'count': 1,
      },
      {
        'text': 'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِن لَّدُنكَ رَحْمَةً ۚ إِنَّكَ أَنتَ الْوَهَّابُ.',
        'source': 'سورة آل عمران ٨',
        'count': 1,
      },
      {
        'text': 'رَبِّ اشْرَحْ لِي صَدْرِي ۝ وَيَسِّرْ لِي أَمْرِي ۝ وَاحْلُلْ عُقْدَةً مِّن لِّسَانِي ۝ يَفْقَهُوا قَوْلِي.',
        'source': 'سورة طه ٢٥-٢٨',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْهُدَى وَالتُّقَى وَالْعَفَافَ وَالْغِنَى.',
        'source': 'رواه مسلم',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، وَأَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ، وَأَعُوذُ بِكَ مِنَ الْجُبْنِ وَالْبُخْلِ، وَأَعُوذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ وَقَهْرِ الرِّجَالِ.',
        'source': 'رواه البخاري',
        'count': 1,
      },
      {
        'text': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا.',
        'source': 'رواه ابن ماجه',
        'count': 1,
      },
      {
        'text': 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ.',
        'source': 'سورة آل عمران ١٧٣',
        'count': 1,
      },
      {
        'text': 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ.',
        'source': 'دعاء يونس — الأنبياء ٨٧',
        'count': 1,
      },
    ],
  };
}

class _AdhkarCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final int index;
  const _AdhkarCard({required this.item, required this.index});

  @override
  State<_AdhkarCard> createState() => _AdhkarCardState();
}

class _AdhkarCardState extends State<_AdhkarCard> {
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.item['count'] as int;
  }

  @override
  Widget build(BuildContext context) {
    final isDone = _remaining == 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: isDone ? null : () => setState(() => _remaining--),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isDone
                          ? Colors.green.withOpacity(0.12)
                          : AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isDone ? '✓ تم' : '$_remaining مرة',
                      style: TextStyle(
                        fontFamily: 'NotoNaskhArabic',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isDone ? Colors.green : AppColors.primary,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.index}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.item['text'] as String,
              style: TextStyle(
                fontFamily: 'AmiriQuran',
                fontSize: 19,
                height: 1.8,
                color: isDone
                    ? AppColors.textSecondary
                    : AppColors.textQuran,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                        text: widget.item['text'] as String));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('تم نسخ الذكر'),
                          duration: Duration(seconds: 1)),
                    );
                  },
                  child: const Icon(Icons.copy_outlined,
                      size: 18, color: AppColors.textSecondary),
                ),
                Text(
                  widget.item['source'] as String,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
