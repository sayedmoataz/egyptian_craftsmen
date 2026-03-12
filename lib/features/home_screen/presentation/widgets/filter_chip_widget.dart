import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:egyptian_craftsmen/core/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class FilterChipItemWidget extends StatelessWidget {
  final String label;
  final IconData iconUri;
  final bool isSelected;
  final ResponsiveInfo info;

  const FilterChipItemWidget({
    required this.label,
    required this.iconUri,
    required this.isSelected,
    required this.info,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: info.spacing(ResponsiveSpacing.md),
        vertical: info.spacing(ResponsiveSpacing.sm),
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryDark : AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusRound),
        border: Border.all(
          color: isSelected ? AppColors.primaryDark : AppColors.neutral200,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.neutral950.withValues(alpha: 0.12),
                  offset: const Offset(4, 4),
                  blurRadius: 12,
                  blurStyle: BlurStyle.inner,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconUri,
            size: info.responsiveFontSize(16),
            color: isSelected ? AppColors.surface : AppColors.neutral900,
          ),
          SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.surface : AppColors.neutral900,
              fontSize: info.responsiveFontSize(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
