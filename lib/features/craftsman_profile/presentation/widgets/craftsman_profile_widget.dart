import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import 'craftsman_main_profile_data_widget.dart';
import 'craftsman_profile_cover.dart';
import 'profile_bottom_widget.dart';

class CraftsmanProfileWidget extends StatelessWidget {
  const CraftsmanProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    // Top Cover Image
                    CraftsmanProfileCover(
                      imageUrl:
                          'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=1000&auto=format&fit=crop',
                      onShare: () {}, // TODO
                      onFavorite: () {}, // TODO
                    ),
                    // Overlapping content
                    const CraftsmanMainProfileDataWidget(),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar
            ProfileBottomWidget(onPressed: () {}),
          ],
        );
      },
    );
  }
}
