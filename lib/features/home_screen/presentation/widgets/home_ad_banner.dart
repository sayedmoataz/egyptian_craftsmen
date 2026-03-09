import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:egyptian_craftsmen/core/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';

class HomeAdBanner extends StatelessWidget {
  final ResponsiveInfo info;
  const HomeAdBanner({required this.info, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: info.responsiveValue(mobile: 156, tablet: 200, desktop: 240),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppConstants.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900.withValues(alpha: 0.15),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image Placeholder
          Positioned.fill(
            child: Container(
              color: AppColors.neutral800,
              child: Icon(
                Icons.image,
                size: info.responsiveValue(mobile: 64, tablet: 80, desktop: 96),
                color: AppColors.surface.withValues(alpha: 0.24),
              ),
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.neutral900,
                    AppColors.neutral900.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            left: info.spacing(ResponsiveSpacing.lg),
            top: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: info.spacing(ResponsiveSpacing.md),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppStrings.of(context).offers,
                    style: TextStyle(
                      fontSize: info.responsiveFontSize(14),
                      color: AppColors.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
                  Text(
                    AppStrings.of(context).specialOfferTitlePart1,
                    style: TextStyle(
                      fontSize: info.responsiveFontSize(18),
                      color: AppColors.neutral50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppStrings.of(context).specialOfferTitlePart2,
                    style: TextStyle(
                      fontSize: info.responsiveFontSize(18),
                      color: AppColors.neutral50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: info.responsiveValue(mobile: 12, tablet: 16),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: info.spacing(ResponsiveSpacing.lg),
                      vertical: info.responsiveValue(mobile: 6, tablet: 8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neutral900.withValues(alpha: 0.25),
                          offset: const Offset(4, 4),
                          blurRadius: 12,
                          blurStyle: BlurStyle.inner,
                        ),
                      ],
                    ),
                    child: Text(
                      AppStrings.of(context).bookNow,
                      style: TextStyle(
                        fontSize: info.responsiveFontSize(10),
                        color: AppColors.neutral50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
