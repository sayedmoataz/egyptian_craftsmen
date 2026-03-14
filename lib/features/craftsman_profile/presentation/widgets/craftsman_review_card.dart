import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:egyptian_craftsmen/core/utils/constants.dart';
import 'package:egyptian_craftsmen/core/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/extensions.dart';

class CraftsmanReviewCard extends StatelessWidget {
  final String reviewerName;
  final String date;
  final String reviewText;
  final double rating;
  final String? avatarUrl;

  const CraftsmanReviewCard({
    required this.reviewerName,
    required this.date,
    required this.reviewText,
    required this.rating,
    this.avatarUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing(ResponsiveSpacing.sm)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User info
              Row(
                children: [
                  Container(
                    width: context.spacing(ResponsiveSpacing.xl),
                    height: context.spacing(ResponsiveSpacing.xl),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neutral200,
                    ),
                    child: avatarUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusLG,
                            ),
                            child: CachedImageWidget(imageUrl: avatarUrl!),
                          )
                        : const Icon(Icons.person, color: AppColors.surface),
                  ),
                  SizedBox(width: context.spacing(ResponsiveSpacing.xs)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviewerName,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: context.responsiveFontSize(12),
                        ),
                      ),
                      Text(
                        date,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: context.responsiveFontSize(9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Rating stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating.round() ? Icons.star : Icons.star_border,
                    color: AppColors.accent,
                    size: context.responsiveFontSize(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.spacing(ResponsiveSpacing.sm)),
          Text(
            '"$reviewText"',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: context.responsiveFontSize(12),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
