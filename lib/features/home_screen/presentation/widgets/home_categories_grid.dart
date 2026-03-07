import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';

class HomeCategoriesGrid extends StatelessWidget {
  const HomeCategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final categories = [
          _CategoryItem(
            title: AppStrings.of(context).plumbing,
            icon: Icons.plumbing,
          ),
          _CategoryItem(
            title: AppStrings.of(context).electricity,
            icon: Icons.electrical_services,
          ),
          _CategoryItem(
            title: AppStrings.of(context).carpentry,
            icon: Icons.handyman,
          ),
          _CategoryItem(
            title: AppStrings.of(context).painting,
            icon: Icons.format_paint,
          ),
          _CategoryItem(
            title: AppStrings.of(context).airConditioning,
            icon: Icons.ac_unit,
          ),
          _CategoryItem(
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
            return _buildCategoryCard(context, info, categories[index]);
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    ResponsiveInfo info,
    _CategoryItem item,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: item.isViewAll
            ? const Color(0xFFF2F2F2).withValues(alpha: 0.05)
            : const Color(0xFFF2F2F2),
        border: item.isViewAll
            ? Border.all(
                color: const Color(0xFF1C3557),
                style: BorderStyle.none,
              ) // Border.dashed is not natively supported out of the box so simulating
            : null,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(info.spacing(ResponsiveSpacing.sm)),
            decoration: BoxDecoration(
              color: const Color(0xFF2E6C99).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, size: 24, color: const Color(0xFF1C3557)),
          ),
          SizedBox(height: info.spacing(ResponsiveSpacing.sm)),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF1E1E1E),
              fontSize: 18,
              fontFamily:
                  'IBM_Plex_Sans_Arabic', // Need to check if available, assuming default otherwise
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final IconData icon;
  final bool isViewAll;

  _CategoryItem({
    required this.title,
    required this.icon,
    this.isViewAll = false,
  });
}
