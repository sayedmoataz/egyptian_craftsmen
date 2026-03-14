import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import 'rating_badge_widget.dart';
import 'user_avatar_widget.dart';
import 'user_info_data_widget.dart';

class CraftsmanMainDataWidget extends StatelessWidget {
  final String name;
  final String profession;
  final int experienceYears;
  final double rating;
  final int reviewCount;
  final String avatarUrl;
  const CraftsmanMainDataWidget({
    required this.name,
    required this.profession,
    required this.experienceYears,
    required this.rating,
    required this.reviewCount,
    required this.avatarUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        UserAvatarWidget(avatarUrl: avatarUrl),
        SizedBox(width: context.spacing(ResponsiveSpacing.md)),
        // Info
        Expanded(
          child: UserInfoDataWidget(
            name: name,
            profession: profession,
            experienceYears: experienceYears,
          ),
        ),
        // Rating Badge
        RatingBadgeWidget(rating: rating, reviewCount: reviewCount),
      ],
    );
  }
}
