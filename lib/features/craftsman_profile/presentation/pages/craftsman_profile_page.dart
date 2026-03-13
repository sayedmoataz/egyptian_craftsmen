import 'package:advanced_responsive/advanced_responsive.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/craftsman_about_section.dart';
import '../widgets/craftsman_info_card.dart';
import '../widgets/craftsman_portfolio_section.dart';
import '../widgets/craftsman_profile_cover.dart';
import '../widgets/craftsman_review_card.dart';
import '../widgets/craftsman_reviews_section.dart';

class CraftsmanProfilePage extends StatelessWidget {
  const CraftsmanProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold background color per Figma
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ResponsiveBuilder(
        builder: (context, info) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      // Top Cover Image
                      CraftsmanProfileCover(
                        // Temporary dummy image matching Figma mockup
                        imageUrl: 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?q=80&w=1000&auto=format&fit=crop',
                        onBack: () => Navigator.of(context).maybePop(),
                        onShare: () {},
                        onFavorite: () {},
                      ),
                      // Overlapping content
                      Padding(
                        padding: EdgeInsets.only(
                          // Overlap the cover image
                          top: 250,
                          left: info.spacing(ResponsiveSpacing.md),
                          right: info.spacing(ResponsiveSpacing.md),
                          bottom: info.spacing(ResponsiveSpacing.xl),
                        ),
                        child: Center(
                          child: Container(
                            constraints: BoxConstraints(maxWidth: info.contentMaxWidth()),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Floating Info Card
                                const CraftsmanInfoCard(
                                  name: 'أحمد خليل',
                                  profession: 'فني كهرباء',
                                  experienceYears: 4,
                                  rating: 4.9,
                                  reviewCount: 128,
                                  successfulServices: 340,
                                  responseTimeMinutes: 30,
                                  avatarUrl: 'https://images.unsplash.com/photo-1540569014015-19a7be504e3a?q=80&w=256&auto=format&fit=crop',
                                ),
                                SizedBox(height: info.spacing(ResponsiveSpacing.xl)),

                                // About Section
                                const CraftsmanAboutSection(
                                  description: 'متخصص في التمديدات الكهربائية السكنية الراقية وتكامل المنازل الذكية. مع أكثر من 4 سنوات من الخبرة في السوق المصري، أقدم حلولاً كهربائية آمنة وفعالة وجذابة للمنازل الحديثة. عملي مضمون ويلتزم بمعايير السلامة الدولية، بالإضافة إلى شهادات معتمدة دولياً في التخصص الكهربائي.',
                                ),
                                SizedBox(height: info.spacing(ResponsiveSpacing.xl)),

                                // Portfolio Section
                                CraftsmanPortfolioSection(
                                  imageUrls: const [
                                    'https://images.unsplash.com/photo-1621905252507-b35492cc74b4?q=80&w=500&auto=format&fit=crop',
                                    'https://images.unsplash.com/photo-1621905251918-4841cbf85cb3?q=80&w=500&auto=format&fit=crop',
                                    'https://images.unsplash.com/photo-1613545325278-f24b0cae1224?q=80&w=500&auto=format&fit=crop',
                                  ],
                                  onViewAll: () {},
                                ),
                                SizedBox(height: info.spacing(ResponsiveSpacing.xl)),

                                // Reviews Section
                                CraftsmanReviewsSection(
                                  onReadAll: () {},
                                  reviewCards: const [
                                    CraftsmanReviewCard(
                                      reviewerName: 'خالد م.',
                                      date: 'قبل يومين',
                                      reviewText: 'محترف للغاية. قام بإصلاح مشكلة معقدة في الأسلاك لم يتمكن ثلاثة كهربائيين آخرين من حلها. شغل نظيف وحديث، بالإضافة إلى الالتزام بالمواعيد',
                                      rating: 5.0,
                                    ),
                                    CraftsmanReviewCard(
                                      reviewerName: 'مريم س.',
                                      date: 'قبل 3 أيام',
                                      reviewText: 'مهندس محترف، ولكن حدث بعض المشاكل في المواعيد.',
                                      rating: 3.0,
                                    ),
                                    CraftsmanReviewCard(
                                      reviewerName: 'مروان ع.',
                                      date: 'قبل أسبوع',
                                      reviewText: 'محترف للغاية. قام بإصلاح مشكلة معقدة في الأسلاك لم يتمكن ثلاثة كهربائيين آخرين من حلها. شغل نظيف وحديث، بالإضافة إلى الالتزام بالمواعيد',
                                      rating: 4.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sticky Bottom Bar
              Container(
                padding: EdgeInsets.only(
                  top: info.spacing(ResponsiveSpacing.md),
                  left: info.spacing(ResponsiveSpacing.md),
                  right: info.spacing(ResponsiveSpacing.md),
                  bottom: context.safePadding.bottom > 0
                      ? context.safePadding.bottom
                      : info.spacing(ResponsiveSpacing.md),
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, -4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: info.contentMaxWidth()),
                    child: CustomButton(
                      text: AppStrings.of(context).bookService,
                      onPressed: () {},
                      color: AppColors.primary,
                      textColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
