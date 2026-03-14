import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/extensions.dart';
import 'title_widget.dart';

class CraftsmanAboutSection extends StatelessWidget {
  final String description;

  const CraftsmanAboutSection({required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWidget(
          icon: Icons.person_outline,
          title: AppStrings.of(context).aboutMe
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
