import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/routes/routes.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../core/utils/constants.dart';
import 'bottom_section_actions.dart';
import 'top_section_info.dart';

class CraftsmanCard extends StatelessWidget {
  final ResponsiveInfo info;
  final String name;
  final int yearsOfExperience;
  final double rating;
  final String imagePath;
  // Badges
  final bool isAvailable;
  final bool isHighestRated;
  final bool isVerified;
  final bool hasHighRate;

  const CraftsmanCard({
    required this.info,
    required this.name,
    required this.yearsOfExperience,
    required this.rating,
    required this.imagePath,
    super.key,
    this.isAvailable = false,
    this.isHighestRated = false,
    this.isVerified = false,
    this.hasHighRate = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.craftsmanProfile);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: info.spacing(ResponsiveSpacing.md)),
        padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.sm)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
      child: Column(
        children: [
          // Top Section: Info + Image
          TopSectionInfo(
            yearsOfExperience: yearsOfExperience,
            rating: rating,
            name: name,
            isAvailable: isAvailable,
            isHighestRated: isHighestRated,
            hasHighRate: hasHighRate,
            isVerified: isVerified,
          ),

          SizedBox(height: info.spacing(ResponsiveSpacing.md)),

          // Bottom Section: Actions
          const BottomSectionActions(),
        ],
      ),
    ),
  );
}
}
