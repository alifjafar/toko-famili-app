import 'dart:ui' show Color;

class ColorBase {
  static const primary = Color(0xFF03AC0E);
  static const primaryDark = Color(0xFF12883E);
  static const white = Color(0xFFFFFFFF);
  static const whiteGray = Color(0xFFf2f2f2);
  static const semiGray = Color(0xffb5bbc5);
  static const gray = Color(0xFFB1B1B1);
  static const blueDark = Color(0xFF707070);
  static final gradientBlackOpacity = [
    Color(0xFF000000).withOpacity(0.1),
    Color(0xFF000000).withOpacity(0.7)
  ];

  static const yellow = Color(0xfffdcc3b);
  static const orange = Color(0xffe8b638);
  static const redOrange = Color(0xffD51414);
}
