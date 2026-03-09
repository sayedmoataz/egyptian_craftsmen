import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_strings.dart';

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
    return Container(
      margin: EdgeInsets.only(bottom: info.spacing(ResponsiveSpacing.md)),
      padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.sm)),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating Badge (Top Left)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: info.responsiveFontSize(12),
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: info.responsiveFontSize(12),
                        fontWeight: FontWeight.w600,
                        color: AppColors.neutral900,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox()),

              // Craftsman Details
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: info.responsiveFontSize(14),
                      fontWeight: FontWeight.w500,
                      color: AppColors.neutral900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'فني كهرباء | ${AppStrings.of(context).yearsOfExperience(yearsOfExperience)}',
                    style: TextStyle(
                      fontSize: info.responsiveFontSize(12),
                      color: AppColors.neutral300,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Wrap Badges
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    alignment: WrapAlignment.end,
                    children: [
                      if (isAvailable)
                        _Badge(label: AppStrings.of(context).available),
                      if (isHighestRated)
                        _Badge(label: AppStrings.of(context).highestRated),
                      if (hasHighRate) const _Badge(label: '+4.5'),
                      if (isVerified)
                        _Badge(label: AppStrings.of(context).verified),
                    ],
                  ),
                ],
              ),
              SizedBox(width: info.spacing(ResponsiveSpacing.sm)),

              // Image Profile
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.neutral200,
                    // Provide a generic person icon if no network image is intended
                    child: Icon(Icons.person, size: 32, color: Colors.white),
                  ),
                  if (isVerified)
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.verified,
                        color: AppColors.primaryDark,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ],
          ),

          SizedBox(height: info.spacing(ResponsiveSpacing.md)),

          // Bottom Section: Actions
          Row(
            children: [
              // Chat Button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      offset: const Offset(4, 4),
                      blurRadius: 12,
                      blurStyle: BlurStyle.inner,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              SizedBox(width: info.spacing(ResponsiveSpacing.sm)),

              // Book Service Button
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        offset: const Offset(4, 4),
                        blurRadius: 12,
                        blurStyle: BlurStyle.inner,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'احـــــجز الخـدمــــة',
                      style: TextStyle(
                        fontFamily:
                            'IBM_Plex_Sans_Arabic', // Keeping it specific here for the design
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral300, width: 0.5),
        borderRadius: BorderRadius.circular(62),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            offset: const Offset(2, 2),
            blurRadius: 8,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_outlined,
            size: 10,
            color: AppColors.primaryDark,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.primaryDark),
          ),
        ],
      ),
    );
  }
}
