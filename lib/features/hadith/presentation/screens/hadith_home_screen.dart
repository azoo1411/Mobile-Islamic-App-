import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/arabic_utils.dart';

class HadithHomeScreen extends StatelessWidget {
  const HadithHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الأحاديث النبوية'),
          actions: [
            IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSearchBar(context),
            const SizedBox(height: 20),
            Text('كتب الحديث', style: AppTypography.heading2),
            const SizedBox(height: 12),
            ...AppConstants.hadithBooks.map((book) => _buildBookCard(context, book)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        textDirection: TextDirection.rtl,
        decoration: const InputDecoration(
          hintText: 'ابحث في الأحاديث...',
          hintStyle: TextStyle(fontFamily: 'NotoNaskhArabic'),
          hintTextDirection: TextDirection.rtl,
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, Map<String, String> book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/hadith/${book['id']}/chapters'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.chevron_left, color: AppColors.textSecondary),
              const Spacer(),
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(book['name']!, style: AppTypography.heading3),
                    const SizedBox(height: 4),
                    Text(
                      '${ArabicUtils.toArabicNumerals(int.parse(book['total']!))} حديث',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.auto_stories,
                    color: AppColors.primary, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
