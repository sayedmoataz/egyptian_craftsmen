import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../../utils/app_strings.dart';
import '../../custom_button.dart';

class OfflineScreen extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onRetry;

  const OfflineScreen({required this.isLoading, this.onRetry, super.key});

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
                  Icon(
                    Icons.wifi_off_rounded,
                    size: info.responsiveValue(mobile: 60, tablet: 80),
                    color: AppColors.textSecondary,
                  ),
                  Text(
                    AppStrings.of(context).youAreOffline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: info.responsiveFontSize(24),
                      fontWeight: FontWeight.w400,
                      height: 1.17,
                    ),
                  ),
                  Text(
                    AppStrings.of(context).youAreOfflineDescription,
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
                    text: AppStrings.of(context).tryAgain,
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
