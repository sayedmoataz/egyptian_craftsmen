import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:egyptian_craftsmen/core/theme/colors.dart';
import 'package:flutter/material.dart';

class CirculraButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const CirculraButtonWidget({
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        padding: context.safePadding / 2,
        decoration: const BoxDecoration(
          color: AppColors.neutral50,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
    );
  }
}
