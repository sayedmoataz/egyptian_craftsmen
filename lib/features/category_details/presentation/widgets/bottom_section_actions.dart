import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';

class BottomSectionActions extends StatelessWidget {
  const BottomSectionActions({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Row(
          children: [
            // Chat Button
            Container(
              width: info.spacing(ResponsiveSpacing.xl),
              height: info.spacing(ResponsiveSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    offset: const Offset(4, 4),
                    blurRadius: 12,
                    blurStyle: BlurStyle.inner,
                  ),
                ],
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                color: AppColors.surface,
                size: info.responsiveFontSize(22),
              ),
            ),
            SizedBox(width: info.spacing(ResponsiveSpacing.sm)),

            // Book Service Button
            Expanded(
              child: Container(
                height: info.spacing(ResponsiveSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral950.withValues(alpha: 0.15),
                      offset: const Offset(4, 4),
                      blurRadius: 12,
                      blurStyle: BlurStyle.inner,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    AppStrings.of(context).bookService,
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: info.responsiveFontSize(14),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
