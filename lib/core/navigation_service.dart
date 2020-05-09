import 'package:flutter/cupertino.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
  new GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName,
      {dynamic arguments, bool replace = false, bool popPrevious = false}) {
    if (replace)
      return navigatorKey.currentState
          .pushReplacementNamed(routeName, arguments: arguments);

    if (popPrevious)
      return navigatorKey.currentState
          .popAndPushNamed(routeName, arguments: arguments);

    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToRemoveUntil(String routeName,
      String backRouteName) {
    return navigatorKey.currentState.pushNamedAndRemoveUntil(
        routeName, ModalRoute.withName(backRouteName));
  }

  void navigateBack() {
    return navigatorKey.currentState.pop();
  }
}
