import 'package:famili/core/data/user_prefs.dart';
import 'package:get_it/get_it.dart';

import 'core/navigation_service.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  var instance = await UserPref.getInstance();
  locator.registerLazySingleton(() => NavigationService());
  locator.registerSingleton<UserPref>(instance);
}
