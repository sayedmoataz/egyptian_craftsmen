import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';

class ProfileBottomWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const ProfileBottomWidget({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Container(
          padding: EdgeInsets.only(
            top: info.spacing(ResponsiveSpacing.md),
            left: info.spacing(ResponsiveSpacing.md),
            right: info.spacing(ResponsiveSpacing.md),
            bottom: context.safePadding.bottom > 0
                ? context.safePadding.bottom
                : info.spacing(ResponsiveSpacing.md),
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, -4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: info.contentMaxWidth()),
              child: CustomButton(
                text: AppStrings.of(context).bookService,
                onPressed: onPressed,
                color: AppColors.primary,
                textColor: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
