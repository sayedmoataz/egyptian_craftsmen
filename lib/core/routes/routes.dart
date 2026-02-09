import 'package:aelanji/features/notifications/presentation/pages/notifications_screen.dart';

import '../../features/about_us/presentation/pages/about_us_screen.dart';
import '../../features/add_product/presentation/pages/add_product_screen.dart';
import '../../features/add_services/presentation/pages/add_service_screen.dart';
import '../../features/agents_support/presentation/pages/agents_support_screen.dart';
import '../../features/all_categories/presentation/pages/all_categories_screen.dart';
import '../../features/auth/create_new_password/presentation/pages/create_new_password_screen.dart';
import '../../features/auth/forget_password/presentation/pages/forget_password_screen.dart';
import '../../features/auth/login_in/presentation/pages/login_screen.dart';
import '../../features/auth/sign_up/presentation/pages/sign_up_screen.dart';
import '../../features/auth/verify_email/presentation/pages/verify_email_screen.dart';
import '../../features/boarding/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/boarding/splash/presentation/pages/splash_screen.dart';
import '../../features/category_details/presentation/pages/category_details_screen.dart';
import '../../features/commercial/domain/entities/ad_entity.dart';
import '../../features/contact_us/presentation/pages/contact_us_screen.dart';
import '../../features/favorites/presentation/pages/favorite_list_screen.dart';
import '../../features/home_screen/domain/entities/category_entity.dart';
import '../../features/home_screen/presentation/pages/main_screen.dart';
import '../../features/product_comments/presentation/pages/product_comments.dart';
import '../../features/product_details/presentation/pages/product_details_screen.dart';
import '../../features/recent_viewed/presentation/pages/recent_viewed_screen.dart';
import '../../features/subscriptions/presentation/pages/plans_and_subscriptions_screen.dart';
import '../../features/terms_and_conditions/presentation/pages/terms_and_conditions_screen.dart';
import '../../features/wanted_fetures/presentation/pages/wanted_items_screen.dart';
import '../widgets/fullscreen_image_viewer.dart';
import 'guards/guards_impl.dart';
import 'route_config.dart';

final routes = [
  RouteConfig(name: Routes.splash, builder: (_, __) => const SplashScreen()),
  RouteConfig(
    name: Routes.onboarding,
    builder: (_, __) => const OnboardingScreen(),
  ),
  RouteConfig(name: Routes.signUp, builder: (_, __) => const SignUpScreen()),
  RouteConfig(name: Routes.login, builder: (_, __) => const LoginScreen()),
  RouteConfig(
    name: Routes.forgetPassword,
    builder: (_, __) => const ForgetPasswordScreen(),
  ),
  RouteConfig(
    name: Routes.verifyEmail,
    builder: (_, args) {
      final arguments = args as Map<String, dynamic>?;
      return VerifyEmailScreen(
        email: arguments?[RouteArguments.email] as String? ?? '',
        nextRoute: arguments?[RouteArguments.nextRoute] as String?,
      );
    },
  ),
  RouteConfig(
    name: Routes.createNewPassword,
    builder: (_, args) {
      final arguments = args as Map<String, dynamic>?;
      return CreateNewPasswordScreen(
        email: arguments?[RouteArguments.email] as String? ?? '',
        code: arguments?[RouteArguments.code] as String? ?? '',
      );
    },
  ),
  RouteConfig(name: Routes.home, builder: (_, __) => const MainScreen()),
  RouteConfig(
    name: Routes.allCategories,
    builder: (_, args) {
      final arguments = args as Map<String, dynamic>?;
      final categories =
          arguments?[RouteArguments.categories] as List<CategoryEntity>? ?? [];
      return AllCategoriesScreen(categories: categories);
    },
  ),
  RouteConfig(
    name: Routes.categoryDetails,
    builder: (_, args) {
      final arguments = args as Map<String, dynamic>?;
      final categoryId = arguments?[RouteArguments.categoryId] as int? ?? 0;
      return CategoryDetailsScreen(categoryId: categoryId);
    },
  ),
  RouteConfig(
    name: Routes.productDetails,
    builder: (_, args) {
      final arguments = args as Map<String, dynamic>?;
      final productId = arguments?[RouteArguments.productId] as int? ?? 0;
      return ProductDetailsScreen(productId: productId);
    },
  ),
  RouteConfig(
    name: Routes.favoriteList,
    builder: (_, __) => const FavoriteListScreen(),
    guards: [AuthGuard()],
  ),

  RouteConfig(
    name: Routes.notifications,
    builder: (_, __) => const NotificationsScreen(),
    guards: [AuthGuard()],
  ),

  RouteConfig(
    name: Routes.fullscreenImageViewer,
    builder: (_, args) {
      final arguments = args as Map<String, dynamic>?;
      final product = arguments?[RouteArguments.product] as AdEntity?;
      return FullscreenImageViewer(product: product);
    },
  ),
  RouteConfig(
    name: Routes.addProduct,
    builder: (_, __) => const AddProductScreen(),
    guards: [AuthGuard()],
  ),
  RouteConfig(
    name: Routes.addService,
    builder: (_, __) => const AddServiceScreen(),
    guards: [AuthGuard()],
  ),
  RouteConfig(
    name: Routes.contactUs,
    builder: (_, __) => const ContactUsScreen(),
  ),
  RouteConfig(
    name: Routes.agentsSupport,
    builder: (_, __) => const AgentsSupportScreen(),
  ),
  RouteConfig(
    name: Routes.recentViewed,
    builder: (_, __) => const RecentViewedScreen(),
  ),
  RouteConfig(
    name: Routes.termsAndConditions,
    builder: (_, __) => const TermsAndConditionsScreen(),
  ),
  RouteConfig(
    name: Routes.planAndSubscription,
    builder: (_, __) => const PlanAndSubscriptionScreen(),
    guards: [AuthGuard()],
  ),
  RouteConfig(
    name: Routes.aboutUs,
    builder: (_, __) => const AboutUsScreen(),
  ),
  RouteConfig(
    name: Routes.wantedItems,
    builder: (_, __) => const WantedItemsScreen(),
    guards: [AuthGuard()],
  ),

  RouteConfig(
    name: Routes.productComments,
    builder: (_, args) {
      final arguments = args as Map<String, dynamic>?;
      final productId = arguments?[RouteArguments.productId] as String? ?? '';
      return ProductCommentsScreen(productId: productId);
    },
  ),
];

/// Application Routes
class Routes {
  Routes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgetPassword = '/forget-password';
  static const String verifyEmail = '/verify-email';
  static const String createNewPassword = '/create-new-password';
  static const String allCategories = '/all-categories';
  static const String categoryDetails = '/category-details';
  static const String productDetails = '/product-details';
  static const String favoriteList = '/favorite-list';
  static const String notifications = '/notifications';
  static const String fullscreenImageViewer = '/fullscreen-image-viewer';
  static const String addProduct = '/add-product';
  static const String addService = '/add-service';
  static const String contactUs = '/contact-us';
  static const String agentsSupport = '/agents-support';
  static const String recentViewed = '/recent-viewed';
  static const String termsAndConditions = '/terms-and-conditions';
  static const String aboutUs = '/about-us';
  static const String planAndSubscription = '/plan-and-subscription';
  static const String wantedItems = '/wanted-items';
  static const String productComments = '/product-comments';
}

class RouteArguments {
  // Verify Email Arguments
  static const String email = 'email';
  static const String nextRoute = 'nextRoute';
  static const String code = 'code';
  // All Categories Arguments
  static const String categories = 'categories';
  // Category Details Arguments
  static const String categoryId = 'categoryId';
  // Product Details Arguments
  static const String productId = 'productId';
  // Fullscreen Image Viewer Arguments
  static const String imageUrl = 'imageUrl';

  static const String product = 'product';
}
