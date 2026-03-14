import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import 'title_widget.dart';

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
        TitleWidget(
          icon: Icons.chat_bubble_outline,
          title: AppStrings.of(context).customerReviews,
          buttonText: AppStrings.of(context).readAll,
          onTap: onReadAll,
        ),
        SizedBox(height: context.spacing(ResponsiveSpacing.sm)),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviewCards.length,
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) =>
              SizedBox(height: context.spacing(ResponsiveSpacing.sm)),
          itemBuilder: (context, index) => reviewCards[index],
        ),
      ],
    );
  }
}
