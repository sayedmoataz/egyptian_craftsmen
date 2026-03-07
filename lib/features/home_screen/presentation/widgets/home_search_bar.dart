import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing(ResponsiveSpacing.md),
        vertical: context.spacing(ResponsiveSpacing.sm),
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: context.colorScheme.onSurfaceVariant),
          SizedBox(width: context.spacing(ResponsiveSpacing.sm)),
          Text(
            'ابحث عن كهربائي،سباك ...',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
