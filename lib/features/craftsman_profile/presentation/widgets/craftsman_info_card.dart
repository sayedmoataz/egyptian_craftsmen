import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/extensions.dart';

class CraftsmanInfoCard extends StatelessWidget {
  final String name;
  final String profession;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final int successfulServices;
  final int responseTimeMinutes;
  final String avatarUrl;

  const CraftsmanInfoCard({
    required this.name,
    required this.profession,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.successfulServices,
    required this.responseTimeMinutes,
    required this.avatarUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(context.spacing(ResponsiveSpacing.md)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.neutral200, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: CachedNetworkImage(
                        imageUrl: avatarUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: AppColors.neutral200),
                        errorWidget: (context, url, error) => const Icon(Icons.person),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: context.spacing(ResponsiveSpacing.md)),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: context.responsiveFontSize(16),
                      ),
                    ),
                    SizedBox(height: context.spacing(ResponsiveSpacing.xs)),
                    Text(
                      '$profession | ${AppStrings.of(context).yearsOfExperience(experienceYears)}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: context.responsiveFontSize(12),
                      ),
                    ),
                    SizedBox(height: context.spacing(ResponsiveSpacing.sm)),
                    // Tag Pills
                    Wrap(
                      spacing: context.spacing(ResponsiveSpacing.xs),
                      runSpacing: context.spacing(ResponsiveSpacing.xs),
                      children: [
                        _buildTagPill(context, AppStrings.of(context).available),
                        _buildTagPill(context, AppStrings.of(context).highestRated),
                        _buildTagPill(context, '+4.5'),
                        _buildTagPill(context, AppStrings.of(context).verified),
                      ],
                    ),
                  ],
                ),
              ),
              // Rating Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: context.responsiveFontSize(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($reviewCount)',
                      style: TextStyle(
                        fontSize: context.responsiveFontSize(10),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.spacing(ResponsiveSpacing.md)),
          const Divider(color: AppColors.neutral200),
          SizedBox(height: context.spacing(ResponsiveSpacing.md)),
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                experienceYears.toString(),
                AppStrings.of(context).yearsOfExperience(experienceYears).replaceAll(experienceYears.toString(), '').trim(),
              ),
              _buildVerticalDivider(),
              _buildStatItem(
                context,
                successfulServices.toString(),
                AppStrings.of(context).successfulService,
              ),
              _buildVerticalDivider(),
              _buildStatItem(
                context,
                responseTimeMinutes.toString(),
                AppStrings.of(context).responseSpeed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagPill(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.neutral300, width: 0.5),
        borderRadius: BorderRadius.circular(72),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified, color: AppColors.primary, size: 10),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: context.responsiveFontSize(9),
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: context.responsiveFontSize(16),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          unit,
          style: context.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: context.responsiveFontSize(12),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1.5,
      height: 24,
      color: AppColors.neutral200,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
