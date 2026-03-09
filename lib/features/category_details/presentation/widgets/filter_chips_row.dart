import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: AppStrings.of(context).filter,
                iconUri: Icons.tune,
                isSelected: false,
                info: info,
              ),
              SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
              _FilterChip(
                label: AppStrings.of(context).highestRated,
                iconUri: Icons.trending_up,
                isSelected: false,
                info: info,
              ),
              SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
              _FilterChip(
                label: '+4.5',
                iconUri: Icons.star,
                isSelected: false,
                info: info,
              ),
              SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
              _FilterChip(
                label: AppStrings.of(context).verified,
                iconUri: Icons.verified,
                isSelected: true,
                info: info,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData iconUri;
  final bool isSelected;
  final ResponsiveInfo info;

  const _FilterChip({
    required this.label,
    required this.iconUri,
    required this.isSelected,
    required this.info,
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
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: isSelected ? AppColors.primaryDark : AppColors.neutral200,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
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
            color: isSelected ? Colors.white : AppColors.neutral900,
          ),
          SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.neutral900,
              fontSize: info.responsiveFontSize(12),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
