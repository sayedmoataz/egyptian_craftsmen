import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import 'stats_item.dart';

class ProfileStatsWidget extends StatelessWidget {
  final int experienceYears;
  final int successfulServices;
  final int responseTimeMinutes;
  const ProfileStatsWidget({
    required this.experienceYears,
    required this.successfulServices,
    required this.responseTimeMinutes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        StatsItem(
          value: experienceYears.toString(),
          unit: AppStrings.of(context)
              .yearsOfExperience(experienceYears)
              .replaceAll(experienceYears.toString(), '')
              .trim(),
        ),
        const VerticalDividerWidget(),
        StatsItem(
          value: successfulServices.toString(),
          unit: AppStrings.of(context).successfulService,
        ),
        const VerticalDividerWidget(),
        StatsItem(
          value: responseTimeMinutes.toString(),
          unit: AppStrings.of(context).responseSpeed,
        ),
      ],
    );
  }
}

class VerticalDividerWidget extends StatelessWidget {
  const VerticalDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.5,
      height: 24,
      color: AppColors.neutral200,
      margin: EdgeInsets.symmetric(
        horizontal: context.spacing(ResponsiveSpacing.md),
      ),
    );
  }
}
