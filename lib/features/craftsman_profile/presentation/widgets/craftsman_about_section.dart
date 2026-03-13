import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/extensions.dart';

class CraftsmanAboutSection extends StatelessWidget {
  final String description;

  const CraftsmanAboutSection({
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person_outline, color: AppColors.primary, size: 20),
            SizedBox(width: context.spacing(ResponsiveSpacing.xs)),
            Text(
              AppStrings.of(context).aboutMe,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFontSize(14),
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing(ResponsiveSpacing.sm)),
        Text(
          description,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontSize: context.responsiveFontSize(12),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
