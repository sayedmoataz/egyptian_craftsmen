import 'analytics_services.dart';


extension AnalyticsServiceExtensions on IAnalyticsService {
  /// Future<void> logLogin({String? method}) async {
  ///   final helper = sl<AnalyticsHelper>();
  ///   await logEvent(helper.createLoginEvent(method: method));
  /// }
  /// 
  /// Future<void> logOpenSubscribeScreen({required bool isSubscribed}) async {
  ///   final helper = sl<AnalyticsHelper>();
  ///   await logScreenView(
  ///     helper.createScreenViewEvent(screenName: 'Subscribe', parameters: {'is_subscribed': isSubscribed.toString()}),
  ///   );
  /// }
  /// 
  /// Future<void> logPayInvoiceEvent({String? screenClass, Map<String, Object>? parameters}) async {
  ///   final helper = sl<AnalyticsHelper>();
  ///   await logEvent(helper.createCustomEvent(eventName: 'Pay_invoice_event', parameters: parameters));
  /// }
}
