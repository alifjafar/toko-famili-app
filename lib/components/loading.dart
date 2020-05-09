import 'package:famili/constants/colors.dart';
import 'package:flutter/material.dart';

Widget circularLoading() {
  return Center(
      child: CircularProgressIndicator(
    valueColor: new AlwaysStoppedAnimation<Color>(ColorBase.primaryDark),
  ));
}
