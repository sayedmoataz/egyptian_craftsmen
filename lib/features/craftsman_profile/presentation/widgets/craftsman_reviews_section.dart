import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/extensions.dart';

class CraftsmanReviewsSection extends StatelessWidget {
  final VoidCallback onReadAll;
  final List<Widget> reviewCards;

  const CraftsmanReviewsSection({
    required this.onReadAll,
    required this.reviewCards,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 20),
                SizedBox(width: context.spacing(ResponsiveSpacing.xs)),
                Text(
                  AppStrings.of(context).customerReviews,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFontSize(14),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: onReadAll,
              child: Text(
                AppStrings.of(context).readAll,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontSize: context.responsiveFontSize(12),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing(ResponsiveSpacing.sm)),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviewCards.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => SizedBox(height: context.spacing(ResponsiveSpacing.sm)),
          itemBuilder: (context, index) => reviewCards[index],
        ),
      ],
    );
  }
}
