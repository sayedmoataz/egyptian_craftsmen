import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:egyptian_craftsmen/core/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class TagPillWidget extends StatelessWidget {
  const TagPillWidget({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing(ResponsiveSpacing.sm),
        vertical: context.spacing(ResponsiveSpacing.xs),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral300, width: 0.5),
        borderRadius: BorderRadius.circular(AppConstants.radiusLG * 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            color: AppColors.primary,
            size: context.responsiveFontSize(9),
          ),
          SizedBox(width: context.spacing(ResponsiveSpacing.xs)),
          Text(
            text,
            style: TextStyle(
              fontSize: context.responsiveFontSize(9),
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
