import 'package:get_it/get_it.dart';

import '../services/general/performance_service.dart';

final sl = GetIt.instance;

void initUseCases() {
  PerformanceService.instance.startOperation('UseCases Init');

  PerformanceService.instance.endOperation('UseCases Init');
}
