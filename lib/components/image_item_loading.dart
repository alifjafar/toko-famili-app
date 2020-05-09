import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ImageItemLoading extends StatelessWidget {
  final width;
  final height;
  final Color color;

  const ImageItemLoading({Key key, this.width, this.height, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        color: color ?? Colors.grey[100],
        child: Align(
            child: Lottie.asset(
          'assets/animations/image-loading.json',
          frameBuilder: (context, child, composition) {
            return AnimatedOpacity(
              child: child,
              opacity: composition == null ? 0 : 1,
              duration: const Duration(seconds: 1),
              curve: Curves.easeOut,
            );
          },
        )));
  }
}
