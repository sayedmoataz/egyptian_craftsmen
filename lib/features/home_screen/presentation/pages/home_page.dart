import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../widgets/home_ad_banner.dart';
import '../widgets/home_categories_grid.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (context, info) {
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing(ResponsiveSpacing.md),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 16),
                      const HomeTopBar(),
                      SizedBox(height: context.spacing(ResponsiveSpacing.lg)),
                      const HomeSearchBar(),
                      SizedBox(height: context.spacing(ResponsiveSpacing.xl)),
                      const HomeAdBanner(),
                      SizedBox(height: context.spacing(ResponsiveSpacing.lg)),
                      const HomeCategoriesGrid(),
                      SizedBox(height: context.spacing(ResponsiveSpacing.xxl)),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.person_outline,
            label: AppStrings.of(context).profileTab,
            isSelected: false,
          ),
          _NavBarItem(
            icon: Icons.account_balance_wallet_outlined,
            label: AppStrings.of(context).walletTab,
            isSelected: false,
          ),
          _NavBarItem(
            icon: Icons.calendar_today_outlined,
            label: AppStrings.of(context).appointmentsTab,
            isSelected: false,
          ),
          _NavBarItem(
            icon: Icons.home,
            label: AppStrings.of(context).homeTab,
            isSelected: true,
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? const Color(0xFF1C3557)
        : const Color(0xFFB3B3B3);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isSelected)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors
                  .transparent, // Placeholder for selected bg circle if needed
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                        blurStyle: BlurStyle.inner, // inner shadow from figma
                      ),
                    ]
                  : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: color),
          )
        else
          Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontFamily: 'IBM_Plex_Sans_Arabic',
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
