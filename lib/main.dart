import 'package:famili/core/routes.dart';
import 'package:famili/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants/colors.dart';
import 'constants/constants.dart';
import 'core/navigation_service.dart';
import 'injection.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await setupLocator();
    runApp(App());
  } catch (error) {
    print('Locator setup has failed');
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: '${Constant.appName}',
      theme: ThemeData(
        primaryColor: ColorBase.primary,
        primaryColorBrightness: Brightness.light,
        accentColor: ColorBase.primary,
        fontFamily: 'NunitoSans'
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: routes,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
