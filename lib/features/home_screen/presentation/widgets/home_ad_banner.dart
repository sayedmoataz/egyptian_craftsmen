import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/extensions.dart';

class HomeAdBanner extends StatelessWidget {
  const HomeAdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 156,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image Placeholder
          Positioned.fill(
            child: Container(
              color: Colors.grey.shade800,
              child: const Icon(Icons.image, size: 64, color: Colors.white24),
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1E1E1E),
                    const Color(0xFF1E1E1E).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            left:
                24, // RTL flips this conceptually, but positioning from left works if app directionality handles it
            top: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: context.spacing(ResponsiveSpacing.md),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppStrings.of(context).offers,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.of(context).specialOfferTitlePart1,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFF2F2F2),
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppStrings.of(context).specialOfferTitlePart2,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color(0xFFF2F2F2),
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C3557),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          offset: const Offset(4, 4),
                          blurRadius: 12,
                          blurStyle: BlurStyle.inner,
                        ),
                      ],
                    ),
                    child: Text(
                      AppStrings.of(context).bookNow,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFFF2F2F2),
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
