import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_network_image.dart';

class UserAvatarWidget extends StatelessWidget {
  final String avatarUrl;
  const UserAvatarWidget({required this.avatarUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.spacing(ResponsiveSpacing.xl) * 2,
          height: context.spacing(ResponsiveSpacing.xl) * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.neutral200, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusRound),
            child: CachedImageWidget(imageUrl: avatarUrl),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(context.spacing(ResponsiveSpacing.xs) / 2),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: context.responsiveFontSize(12),
            ),
          ),
        ),
      ],
    );
  }
}
