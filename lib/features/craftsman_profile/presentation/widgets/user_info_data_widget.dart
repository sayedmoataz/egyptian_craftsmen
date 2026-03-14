import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/extensions.dart';
import 'tag_pill_widget.dart';

class UserInfoDataWidget extends StatelessWidget {
  const UserInfoDataWidget({
    required this.name,
    required this.profession,
    required this.experienceYears,
    super.key,
  });

  final String name;
  final String profession;
  final int experienceYears;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFontSize(16),
          ),
        ),
        SizedBox(height: context.spacing(ResponsiveSpacing.xs)),
        Text(
          '$profession | ${AppStrings.of(context).yearsOfExperience(experienceYears)}',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontSize: context.responsiveFontSize(12),
          ),
        ),
        SizedBox(height: context.spacing(ResponsiveSpacing.sm)),
        // Tag Pills
        Wrap(
          spacing: context.spacing(ResponsiveSpacing.xs),
          runSpacing: context.spacing(ResponsiveSpacing.xs),
          children: [
            TagPillWidget(text: AppStrings.of(context).available),
            TagPillWidget(text: AppStrings.of(context).highestRated),
            const TagPillWidget(text: '+4.5'),
            TagPillWidget(text: AppStrings.of(context).verified),
          ],
        ),
      ],
    );
  }
}
