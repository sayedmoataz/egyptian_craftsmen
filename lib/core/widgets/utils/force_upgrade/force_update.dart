import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../gen/assets.gen.dart';
import '../../../theme/colors.dart';
import '../../../utils/app_strings.dart';
import '../../custom_button.dart';

class ForceUpdate extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onRetry;

  const ForceUpdate({required this.isLoading, this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Padding(
            padding: info.safePadding,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: info.responsiveValue(mobile: 24, tablet: 24),
                children: [
                  Assets.icons.utils.systemUpdate01.image(
                    width: info.responsiveValue(mobile: 60, tablet: 80),
                    height: info.responsiveValue(mobile: 60, tablet: 80),
                  ),
                  Text(
                    AppStrings.of(context).forceUpdate,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: info.responsiveFontSize(24),
                      fontWeight: FontWeight.w400,
                      height: 1.17,
                    ),
                  ),
                  Text(
                    AppStrings.of(context).forceUpdateDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: info.responsiveFontSize(16),
                      fontWeight: FontWeight.w400,
                      height: 1.75,
                    ),
                  ),
                  CustomButton(
                    onPressed: onRetry ?? () {},
                    text: AppStrings.of(context).updateNow,
                    isLoading: isLoading,
                    color: AppColors.primary,
                    textColor: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
