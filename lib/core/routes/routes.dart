import 'package:egyptian_craftsmen/core/routes/route_config.dart';

import '../../features/home_screen/presentation/pages/home_page.dart';
import '../../features/login/presentation/pages/login_screen.dart';

final routes = [
  RouteConfig(name: Routes.login, builder: (_, _) => const LoginScreen()),
  RouteConfig(name: Routes.home, builder: (_, _) => const HomePage()),
];

/// Application Routes
class Routes {
  Routes._();

  static const String login = '/login';
  static const String home = '/home';
}

class RouteArguments {
  // Verify Email Arguments
  static const String email = 'email';
}
