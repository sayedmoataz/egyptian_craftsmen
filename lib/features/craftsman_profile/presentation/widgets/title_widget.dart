import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/extensions.dart';

class TitleWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? buttonText;
  final VoidCallback? onTap;
  const TitleWidget({
    required this.icon,
    required this.title,
    this.buttonText,
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: context.responsiveFontSize(20),
            ),
            SizedBox(width: context.spacing(ResponsiveSpacing.xs)),
            Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: context.responsiveFontSize(14),
              ),
            ),
          ],
        ),
        if (onTap != null && buttonText != null)
          InkWell(
            onTap: onTap,
            child: Text(
              buttonText!,
              style: context.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontSize: context.responsiveFontSize(12),
              ),
            ),
          ),
      ],
    );
  }
}
