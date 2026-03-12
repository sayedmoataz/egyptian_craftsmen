import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../home_screen/data/models/category_model.dart';
import '../../../home_screen/presentation/widgets/home_search_bar.dart';
import 'category_details_top_bar.dart';
import 'craftsman_card.dart';
import 'filter_chips_row.dart';

class CategoryDetailsWidget extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoryDetailsWidget({required this.categoryModel, super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Column(
          children: [
            // Fixed Header
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: info.spacing(ResponsiveSpacing.md),
              ),
              child: Column(
                children: [
                  SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                  const CategoryDetailsTopBar(),
                  SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                  const HomeSearchBar(),
                  SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                  const FilterChipsRow(),
                  SizedBox(height: info.spacing(ResponsiveSpacing.md)),
                ],
              ),
            ),

            // Scrollable List
            Expanded(
              child: Container(
                color: AppColors.background,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: info.spacing(ResponsiveSpacing.md),
                    vertical: info.spacing(ResponsiveSpacing.sm),
                  ),
                  child: Column(
                    children: [
                      CraftsmanCard(
                        info: info,
                        name: 'أحمد خليل',
                        yearsOfExperience: 4,
                        rating: 4.9,
                        imagePath: '',
                        isAvailable: true,
                        isHighestRated: true,
                        hasHighRate: true,
                        isVerified: true,
                      ),
                      CraftsmanCard(
                        info: info,
                        name: 'مصطفي علي',
                        yearsOfExperience: 3,
                        rating: 4.3,
                        imagePath: '',
                        isAvailable: true,
                      ),
                      CraftsmanCard(
                        info: info,
                        name: 'محمد درويش',
                        yearsOfExperience: 6,
                        rating: 4.9,
                        imagePath: '',
                        isAvailable: true,
                        isHighestRated: true,
                        hasHighRate: true,
                        isVerified: true,
                      ),
                      CraftsmanCard(
                        info: info,
                        name: 'مروان سعيد',
                        yearsOfExperience: 2,
                        rating: 4.6,
                        imagePath: '',
                        isAvailable: true,
                        hasHighRate: true,
                      ),
                      SizedBox(height: info.spacing(ResponsiveSpacing.xxl)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
