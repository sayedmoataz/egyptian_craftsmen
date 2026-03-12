import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../home_screen/presentation/widgets/filter_chip_widget.dart';

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterChipItemWidget(
                label: AppStrings.of(context).filter,
                iconUri: Icons.tune,
                isSelected: false,
                info: info,
              ),
              SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
              FilterChipItemWidget(
                label: AppStrings.of(context).highestRated,
                iconUri: Icons.trending_up,
                isSelected: false,
                info: info,
              ),
              SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
              FilterChipItemWidget(
                label: '+4.5',
                iconUri: Icons.star,
                isSelected: false,
                info: info,
              ),
              SizedBox(width: info.spacing(ResponsiveSpacing.xs)),
              FilterChipItemWidget(
                label: AppStrings.of(context).verified,
                iconUri: Icons.verified,
                isSelected: true,
                info: info,
              ),
            ],
          ),
        );
      },
    );
  }
}
