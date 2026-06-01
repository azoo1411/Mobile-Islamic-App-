import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/arabic_text.dart';
import '../providers/poetry_provider.dart';

class PoetryReaderScreen extends ConsumerWidget {
  final String categoryId;

  const PoetryReaderScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poemsAsync = ref.watch(poetryCategoryProvider(categoryId));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_categoryName(categoryId)),
          leading: const BackButton(),
        ),
        body: poemsAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (poems) => poems.isEmpty
              ? _buildEmpty()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: poems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _buildPoemCard(context, poems[index]),
                ),
        ),
      ),
    );
  }

  Widget _buildPoemCard(BuildContext context, dynamic poem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(maxWidth: 36, maxHeight: 36),
                      icon: const Icon(Icons.share_outlined,
                          color: AppColors.textSecondary),
                      onPressed: () {},
                    ),
                    IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(maxWidth: 36, maxHeight: 36),
                      icon: const Icon(Icons.copy,
                          color: AppColors.textSecondary),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: poem.poemText));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('تم نسخ القصيدة',
                                  textDirection: TextDirection.rtl)),
                        );
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(poem.title, style: AppTypography.heading3),
                    Text(poem.poet,
                        style: AppTypography.caption
                            .copyWith(color: AppColors.primary)),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),
            PoetryText(poem.poemText),
            if (poem.era != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  poem.era!,
                  style: AppTypography.caption,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('📖', style: TextStyle(fontSize: 48)),
          SizedBox(height: 16),
          Text(
            'لا توجد قصائد في هذا التصنيف بعد',
            style: AppTypography.body,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  String _categoryName(String id) {
    return AppConstants.poetryCategories
        .firstWhere((c) => c['id'] == id,
            orElse: () => {'name': 'قصائد'})['name']!;
  }
}
