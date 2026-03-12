import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../widgets/home_ad_banner.dart';
import '../widgets/home_categories_grid.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacing(ResponsiveSpacing.md),
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: context.spacing(ResponsiveSpacing.md)),
                  const HomeTopBar(),
                  SizedBox(height: context.spacing(ResponsiveSpacing.lg)),
                  const HomeSearchBar(),
                  SizedBox(height: context.spacing(ResponsiveSpacing.xl)),
                  HomeAdBanner(info: info),
                  SizedBox(height: context.spacing(ResponsiveSpacing.lg)),
                  const HomeCategoriesGrid(),
                  SizedBox(height: context.spacing(ResponsiveSpacing.xxl)),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}
