import 'package:egyptian_craftsmen/core/routes/route_config.dart';

import '../../features/category_details/presentation/pages/category_details_screen.dart';
import '../../features/home_screen/data/models/category_model.dart';
import '../../features/home_screen/presentation/pages/home_page.dart';
import '../../features/login/presentation/pages/login_screen.dart';

final routes = [
  RouteConfig(name: Routes.login, builder: (_, _) => const LoginScreen()),
  RouteConfig(name: Routes.home, builder: (_, _) => const HomeScreen()),
  RouteConfig(
    name: Routes.categoryDetails,
    builder: (context, args) =>
        CategoryDetailsScreen(categoryModel: args as CategoryModel),
  ),
];

/// Application Routes
class Routes {
  Routes._();

  static const String login = '/login';
  static const String home = '/home';
  static const String categoryDetails = '/category_details';
}

class RouteArguments {
  // Verify Email Arguments
  static const String email = 'email';
  static const String categoryModel = 'category_model';
}
