import '../../api/contracts/api_consumer.dart';
import '../../api/factory/network_service_factory.dart';
import '../../api/request_handler/request_queue.dart';
import '../../config/app_config.dart';
import '../../di/injection_container.dart';
import '../../network/network_info.dart';
import '../../services/caching/managers/app_prefs_manager.dart';
import '../../services/general/performance_service.dart';

Future<void> initNetworking() async {
  PerformanceService.instance.startOperation('API Networking Init');

  final apiConsumer = NetworkServiceFactory.create(
    baseUrl: AppConfig.baseUrl,
    getToken: () => sl<AppPrefsManager>().getToken(),
    getRefreshToken: () => sl<AppPrefsManager>().getRefreshToken(),
    getLanguage: () => sl<AppPrefsManager>().getLanguage(),
    getCountryId: () => sl<AppPrefsManager>().getSelectedCountryId(),
    enableLogging: AppConfig.enableLogging,
    enableCache: true,
  );

  sl.registerLazySingleton<ApiConsumer>(() => apiConsumer);

  // Register RequestQueue with NetworkInfo for auto-processing on reconnect
  final requestQueue = RequestQueue(sl<NetworkInfo>());
  requestQueue.consumer = apiConsumer;
  sl.registerLazySingleton<RequestQueue>(() => requestQueue);

  PerformanceService.instance.endOperation('API Networking Init');
}
