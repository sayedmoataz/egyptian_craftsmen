import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';

class HomeSearchBar extends StatelessWidget {
  final String? hint;
  const HomeSearchBar({super.key, this.hint});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hint: hint ?? AppStrings.of(context).searchPlaceholderElectrician,
      prefixIcon: Icon(
        Icons.search,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
