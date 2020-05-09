import 'package:famili/constants/navigation.dart';
import 'package:famili/screens/main_screen.dart';
import 'package:flutter/material.dart';

Route routes(RouteSettings settings) {
  var args = settings.arguments;

  switch(settings.name) {
    case NavigationConstant.Home:
      return buildRoute(settings, MainScreen());
    default:
      return buildRoute(settings, MainScreen());
  }
}

MaterialPageRoute buildRoute(RouteSettings settings, Widget builder) {
  return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => builder
  );
}