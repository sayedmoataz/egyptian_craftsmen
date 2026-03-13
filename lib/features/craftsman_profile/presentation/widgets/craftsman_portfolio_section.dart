import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/extensions.dart';

class CraftsmanPortfolioSection extends StatelessWidget {
  final List<String> imageUrls;
  final VoidCallback onViewAll;

  const CraftsmanPortfolioSection({
    required this.imageUrls,
    required this.onViewAll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.image_outlined, color: AppColors.primary, size: 20),
                SizedBox(width: context.spacing(ResponsiveSpacing.xs)),
                Text(
                  AppStrings.of(context).portfolio,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: context.responsiveFontSize(14),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: onViewAll,
              child: Text(
                AppStrings.of(context).viewAll,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontSize: context.responsiveFontSize(12),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: context.spacing(ResponsiveSpacing.sm)),
        SizedBox(
          height: 156,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            separatorBuilder: (context, index) => SizedBox(width: context.spacing(ResponsiveSpacing.sm)),
            itemBuilder: (context, index) {
              return Container(
                width: 156,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: const Offset(-2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: AppColors.neutral200),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
