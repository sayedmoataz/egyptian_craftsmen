import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/widgets/custom_text_field.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hint: 'ابحث عن كهربائي،سباك ...',
      prefixIcon: Icon(
        Icons.search,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
