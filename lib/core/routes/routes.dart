import 'package:egyptian_craftsmen/core/routes/route_config.dart';

import '../../features/login/presentation/pages/login_screen.dart';

final routes = [
  RouteConfig(name: Routes.login, builder: (_, _) => const LoginScreen()),
];

/// Application Routes
class Routes {
  Routes._();

  static const String login = '/login';
}

class RouteArguments {
  // Verify Email Arguments
  static const String email = 'email';
}
