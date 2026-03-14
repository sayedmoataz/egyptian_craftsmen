import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:egyptian_craftsmen/core/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_network_image.dart';
import 'title_widget.dart';

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
        TitleWidget(
          icon: Icons.image_outlined,
          title: AppStrings.of(context).portfolio,
          buttonText: AppStrings.of(context).viewAll,
          onTap: onViewAll,
        ),
        SizedBox(height: context.spacing(ResponsiveSpacing.sm)),
        SizedBox(
          height: 156,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: context.spacing(ResponsiveSpacing.sm)),
            itemBuilder: (context, index) {
              return Container(
                width: 156,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral600.withOpacity(0.15),
                      offset: const Offset(-2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMD),
                  child: CachedImageWidget(imageUrl: imageUrls[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
