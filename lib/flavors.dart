enum Flavor {
  dev,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Egyptian Craftsmen Dev';
      case Flavor.prod:
        return 'Egyptian Craftsmen';
      default:
        return 'Egyptian Craftsmen';
    }
  }

  // Helpers
  static bool get isDev => appFlavor == Flavor.dev;
  static bool get isProd => appFlavor == Flavor.prod;
}