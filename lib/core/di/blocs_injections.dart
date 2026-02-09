import 'package:get_it/get_it.dart';

import '../services/general/performance_service.dart';

final sl = GetIt.instance;

void initBlocs() {
  PerformanceService.instance.startOperation('BLoCs Init');

  PerformanceService.instance.endOperation('BLoCs Init');
}
