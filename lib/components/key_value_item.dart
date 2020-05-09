import 'package:flutter/cupertino.dart';

class KeyValueItem extends StatelessWidget {
  final Widget left;
  final Widget right;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  const KeyValueItem(
      {Key key, this.left, this.right, this.margin, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultMargin = EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0);
    final defaultPadding = EdgeInsets.zero;

    return Container(
      margin: margin ?? defaultMargin,
      padding: padding ?? defaultPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[left, right],
      ),
    );
  }
}
