import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import 'status_badge_widget.dart';

class TopSectionInfo extends StatelessWidget {
  final double rating;
  final String name;
  final int yearsOfExperience;
  final bool isAvailable;
  final bool isHighestRated;
  final bool hasHighRate;
  final bool isVerified;
  const TopSectionInfo({
    required this.rating,
    required this.name,
    required this.yearsOfExperience,
    required this.isAvailable,
    required this.isHighestRated,
    required this.hasHighRate,
    required this.isVerified,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating Badge (Top Left)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: info.spacing(ResponsiveSpacing.sm),
                vertical: info.spacing(ResponsiveSpacing.xs),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    size: info.responsiveFontSize(12),
                    color: AppColors.primaryDark,
                  ),
                  SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
                  Text(
                    rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: info.responsiveFontSize(12),
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral900,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: info.spacing(ResponsiveSpacing.sm)),

            // Craftsman Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: info.responsiveFontSize(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.neutral900,
                    ),
                  ),
                  SizedBox(height: info.spacing(ResponsiveSpacing.xs)),
                  Text(
                    '${AppStrings.of(context).electrician} | ${AppStrings.of(context).yearsOfExperience(yearsOfExperience)}',
                    style: TextStyle(
                      fontSize: info.responsiveFontSize(12),
                      color: AppColors.neutral300,
                    ),
                  ),
                  SizedBox(height: info.spacing(ResponsiveSpacing.sm)),

                  // Wrap Badges
                  Wrap(
                    spacing: info.spacing(ResponsiveSpacing.xs),
                    runSpacing: info.spacing(ResponsiveSpacing.xs),
                    children: [
                      if (isAvailable)
                        StatusBadgeWidget(
                          label: AppStrings.of(context).available,
                          icon: Icons.verified_outlined,
                        ),
                      if (isHighestRated)
                        StatusBadgeWidget(
                          label: AppStrings.of(context).highestRated,
                          icon: Icons.verified_outlined,
                        ),
                      if (hasHighRate)
                        const StatusBadgeWidget(
                          label: '+4.5',
                          icon: Icons.star,
                        ),
                      if (isVerified)
                        StatusBadgeWidget(
                          label: AppStrings.of(context).verified,
                          icon: Icons.verified_outlined,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: info.spacing(ResponsiveSpacing.sm)),

            // Image Profile
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.neutral200,
                  // Provide a generic person icon if no network image is intended
                  child: Icon(
                    Icons.person,
                    size: info.responsiveFontSize(24),
                    color: AppColors.surface,
                  ),
                ),
                if (isVerified)
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.verified,
                      color: AppColors.primaryDark,
                      size: info.responsiveFontSize(16),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
