import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:egyptian_craftsmen/core/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class RatingBadgeWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;
  const RatingBadgeWidget({
    required this.rating,
    required this.reviewCount,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing(ResponsiveSpacing.xs),
        vertical: context.spacing(ResponsiveSpacing.sm),
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: AppColors.accent,
            size: context.responsiveFontSize(12),
          ),
          SizedBox(width: context.spacing(ResponsiveSpacing.xs)),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: context.responsiveFontSize(12),
              fontWeight: FontWeight.bold,
              color: AppColors.surface,
            ),
          ),
          SizedBox(width: context.spacing(ResponsiveSpacing.xs)),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: context.responsiveFontSize(10),
              color: AppColors.surface,
            ),
          ),
        ],
      ),
    );
  }
}
