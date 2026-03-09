import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../data/models/category_model.dart';
import 'category_card_widget.dart';

class HomeCategoriesGrid extends StatelessWidget {
  const HomeCategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final categories = [
          CategoryModel(
            title: AppStrings.of(context).plumbing,
            icon: Icons.plumbing,
          ),
          CategoryModel(
            title: AppStrings.of(context).electricity,
            icon: Icons.electrical_services,
          ),
          CategoryModel(
            title: AppStrings.of(context).carpentry,
            icon: Icons.handyman,
          ),
          CategoryModel(
            title: AppStrings.of(context).painting,
            icon: Icons.format_paint,
          ),
          CategoryModel(
            title: AppStrings.of(context).airConditioning,
            icon: Icons.ac_unit,
          ),
          CategoryModel(
            title: AppStrings.of(context).viewAll,
            icon: Icons.grid_view,
            isViewAll: true,
          ),
        ];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: info.responsiveValue(
              mobile: 2,
              tablet: 4,
              desktop: 6,
            ),
            mainAxisSpacing: info.spacing(ResponsiveSpacing.md),
            crossAxisSpacing: info.spacing(ResponsiveSpacing.md),
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return CategoryCardWidget(info: info, item: categories[index]);
          },
        );
      },
    );
  }
}
