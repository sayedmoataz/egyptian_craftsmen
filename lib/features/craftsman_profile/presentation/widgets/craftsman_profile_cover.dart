import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/navigation/navigation_extensions.dart';
import '../../../../core/widgets/custom_network_image.dart';
import 'circulra_button_widget.dart';

class CraftsmanProfileCover extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onShare;
  final VoidCallback onFavorite;

  const CraftsmanProfileCover({
    required this.imageUrl,
    required this.onShare,
    required this.onFavorite,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 308,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedImageWidget(imageUrl: imageUrl),
          // Top Buttons
          Positioned(
            top:
                context.safePadding.top + context.spacing(ResponsiveSpacing.sm),
            left: context.spacing(ResponsiveSpacing.md),
            right: context.spacing(ResponsiveSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CirculraButtonWidget(
                  icon: Icons.arrow_back_ios_new,
                  onTap: context.pop,
                ),
                Row(
                  children: [
                    CirculraButtonWidget(
                      icon: Icons.share_outlined,
                      onTap: onShare,
                    ),
                    SizedBox(width: context.spacing(ResponsiveSpacing.xs)),
                    CirculraButtonWidget(
                      icon: Icons.favorite_border,
                      onTap: onFavorite,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
