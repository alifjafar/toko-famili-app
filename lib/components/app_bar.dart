import 'package:famili/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarMV extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final Color color;
  final double elevation;
  final bool transparentTheme;
  final List<Widget> actions;
  final Widget titleWidget;
  final bool centerTitle;
  final Widget leading;

  AppBarMV({Key key,
    this.title,
    this.backgroundColor = ColorBase.white,
    this.color,
    this.elevation = 0.0,
    this.transparentTheme = false,
    this.actions,
    this.titleWidget, this.centerTitle = false, this.leading})
      : super(key: key);

  AppBarMV.transparent({
    this.title = "",
    this.backgroundColor = Colors.transparent,
    this.color = ColorBase.white,
    this.elevation = 0.0,
    this.transparentTheme = true,
    this.actions,
    this.titleWidget, this.centerTitle = false, this.leading});

  AppBarMV.titleWidget({
    this.title,
    this.backgroundColor = ColorBase.white,
    this.color,
    this.elevation,
    this.transparentTheme = false,
    this.actions,
    this.titleWidget,
    this.centerTitle = false, this.leading
  });

  Brightness changeBrightness(TargetPlatform platform, bool isTransparent) {
    if (platform == TargetPlatform.iOS) {
      if (isTransparent) {
        return Brightness.dark;
      } else {
        return Brightness.light;
      }
    } else {
      return Brightness.light;
    }
  }

  @override
  Widget build(BuildContext context) {
    var platform = Theme.of(context).platform;
    return AppBar(
        title: titleWidget != null ? titleWidget : Text(
          title ?? "",
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        leading: leading ?? null,
        centerTitle: centerTitle,
        backgroundColor: backgroundColor ?? null,
        iconTheme: IconThemeData(color: color),
        brightness: changeBrightness(platform, transparentTheme),
        elevation: elevation ?? null,
        actions: actions != null ? actions : null,
        flexibleSpace: transparentTheme
            ? Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.black87, Colors.transparent])))
            : null);
  }

  @override
  Size get preferredSize => Size.fromHeight(60.0);
}
