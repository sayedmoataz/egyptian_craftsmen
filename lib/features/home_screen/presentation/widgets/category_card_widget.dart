import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../data/models/category_model.dart';

class CategoryCardWidget extends StatelessWidget {
  final ResponsiveInfo info;
  final CategoryModel item;
  const CategoryCardWidget({required this.info, required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!item.isViewAll) {
          Navigator.pushNamed(context, Routes.categoryDetails, arguments: item);
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: item.isViewAll
              ? AppColors.neutral100.withValues(alpha: 0.05)
              : AppColors.neutral100,
          border: item.isViewAll
              ? Border.all(color: AppColors.primary, style: BorderStyle.none)
              : null,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.neutral950.withValues(alpha: 0.15),
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.sm)),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, size: 24, color: AppColors.primary),
            ),
            SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.neutral900,
                fontSize: info.responsiveFontSize(18),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
