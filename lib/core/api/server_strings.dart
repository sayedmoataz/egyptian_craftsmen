/// API Endpoint Strings
class ServerStrings {
  ServerStrings._();

  // Authentication Endpoints
  static const String loginUrl = '/client/login';
  
  // Rate Product
  static String rateProductUrl(int productId) => '/client/products/$productId/rate';
}
