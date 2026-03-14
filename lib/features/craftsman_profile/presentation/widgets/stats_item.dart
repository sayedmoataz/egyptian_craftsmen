import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/extensions.dart';

class StatsItem extends StatelessWidget {
  final String value;
  final String unit;
  const StatsItem({required this.value, required this.unit, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFontSize(16),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          unit,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: context.responsiveFontSize(12),
          ),
        ),
      ],
    );
  }
}
