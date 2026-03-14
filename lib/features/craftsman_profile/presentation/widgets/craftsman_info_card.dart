import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:egyptian_craftsmen/core/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import 'craftsman_main_data_widget.dart';
import 'profile_stats_widget.dart';

class CraftsmanInfoCard extends StatelessWidget {
  final String name;
  final String profession;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final int successfulServices;
  final int responseTimeMinutes;
  final String avatarUrl;

  const CraftsmanInfoCard({
    required this.name,
    required this.profession,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.successfulServices,
    required this.responseTimeMinutes,
    required this.avatarUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral200.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(context.spacing(ResponsiveSpacing.md)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CraftsmanMainDataWidget(
            name: name,
            profession: profession,
            experienceYears: experienceYears,
            rating: rating,
            reviewCount: reviewCount,
            avatarUrl: avatarUrl,
          ),
          SizedBox(height: context.spacing(ResponsiveSpacing.md)),
          const Divider(color: AppColors.neutral200),
          SizedBox(height: context.spacing(ResponsiveSpacing.md)),

          // Stats Row
          ProfileStatsWidget(
            experienceYears: experienceYears,
            successfulServices: successfulServices,
            responseTimeMinutes: responseTimeMinutes,
          ),
        ],
      ),
    );
  }
}
