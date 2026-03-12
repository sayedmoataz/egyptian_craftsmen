import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/extensions.dart';

class CategoryDetailsTopBar extends StatelessWidget {
  const CategoryDetailsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Right Side (RTL) - Location
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: context.colorScheme.onSurfaceVariant,
                  size: info.responsiveFontSize(24),
                ),
                SizedBox(width: info.spacing(ResponsiveSpacing.sm)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.of(context).autoDetectLocation,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: AppColors.neutral400,
                        fontSize: info.responsiveFontSize(10),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          AppStrings.of(context).maadiCairo,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: info.responsiveFontSize(14),
                            color: AppColors.neutral900,
                          ),
                        ),
                        SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.neutral900,
                          size: info.responsiveFontSize(16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Left Side (RTL) - Notification
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_outlined,
                    size: info.responsiveFontSize(28),
                  ),
                  color: AppColors.primaryDark,
                ),
                PositionedDirectional(
                  end: info.spacing(ResponsiveSpacing.xs),
                  top: info.spacing(ResponsiveSpacing.xs),
                  child: Container(
                    padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.xs)),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryDark,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: info.responsiveFontSize(10),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
