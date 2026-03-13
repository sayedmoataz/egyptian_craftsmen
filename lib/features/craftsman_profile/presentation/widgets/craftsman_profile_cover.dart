import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class CraftsmanProfileCover extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onFavorite;

  const CraftsmanProfileCover({
    required this.imageUrl,
    required this.onBack,
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
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppColors.neutral200,
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.neutral200,
              child: const Icon(Icons.error),
            ),
          ),
          // Dark overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Top Buttons
          Positioned(
            top: context.safePadding.top + context.spacing(ResponsiveSpacing.sm),
            left: context.spacing(ResponsiveSpacing.md),
            right: context.spacing(ResponsiveSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: onBack,
                ),
                Row(
                  children: [
                    _buildCircularButton(
                      icon: Icons.share_outlined,
                      onTap: onShare,
                    ),
                    SizedBox(width: context.spacing(ResponsiveSpacing.xs)),
                    _buildCircularButton(
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

  Widget _buildCircularButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
