import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:egyptian_craftsmen/core/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class StatusBadgeWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const StatusBadgeWidget({required this.label, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: info.spacing(ResponsiveSpacing.xs), vertical: info.spacing(ResponsiveSpacing.xs)),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral300, width: 0.5),
            borderRadius: BorderRadius.circular(AppConstants.radiusRound),
            boxShadow: [
              BoxShadow(
                color: AppColors.neutral950.withValues(alpha: 0.12),
                offset: const Offset(2, 2),
                blurRadius: 8,
                blurStyle: BlurStyle.inner,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: info.responsiveFontSize(10),
                color: AppColors.primaryDark,
              ),
              SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
              Text(
                label,
                style: TextStyle(fontSize: info.responsiveFontSize(10), color: AppColors.primaryDark),
              ),
            ],
          ),
        );
      }
    );
  }
}