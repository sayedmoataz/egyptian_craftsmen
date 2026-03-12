import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../utils/app_strings.dart';
import '../../utils/constants.dart';
import 'bottom_bar_item_widget.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: AppColors.neutral200,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusMD)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral900,
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavBarItem(
            icon: Icons.person_outline,
            label: AppStrings.of(context).profileTab,
            isSelected: false,
          ),
          NavBarItem(
            icon: Icons.account_balance_wallet_outlined,
            label: AppStrings.of(context).walletTab,
            isSelected: false,
          ),
          NavBarItem(
            icon: Icons.calendar_today_outlined,
            label: AppStrings.of(context).appointmentsTab,
            isSelected: false,
          ),
          NavBarItem(
            icon: Icons.home,
            label: AppStrings.of(context).homeTab,
            isSelected: true,
          ),
        ],
      ),
    );
  }
}
