import 'package:flutter/material.dart';
import '../skeleton.dart';

class ProductListHorizontalLoading extends StatelessWidget {
  bool withHeading;

  ProductListHorizontalLoading() {
    withHeading = true;
  }

  ProductListHorizontalLoading.withoutHeading() {
    withHeading = false;
  }

  _buildLoading(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Visibility(
        visible: withHeading,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 6.0),
          child: Skeleton(
            height: 20.0,
            width: MediaQuery.of(context).size.width / 4,
            padding: 10.0,
          ),
        ),
      ),
      Container(height: 200.0, child: _buildProductItemLoading())
    ]);
  }

  _buildProductItemLoading() {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        itemBuilder: (context, index) {
          MediaQueryData mediaQuery = MediaQuery.of(context);
          return Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 20.0,
                  color: Colors.black.withOpacity(.2),
                  offset: Offset(4.0, 4.0),
                  spreadRadius: -20,
                ),
              ], borderRadius: BorderRadius.circular(12.0)),
              width: 140,
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(6.0),
                              topLeft: Radius.circular(6.0)),
                          child: Skeleton(
                              height: 100.0, width: mediaQuery.size.width),
                        ),
                      ],
                    )),
                    Padding(
                        padding:
                            EdgeInsets.only(right: 8.0, left: 8.0, top: 6.0),
                        child: Skeleton(
                            height: 12.0, width: mediaQuery.size.width / 4)),
                    Padding(
                        padding:
                            EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
                        child: Skeleton(
                          height: 10.0,
                          width: mediaQuery.size.width / 8,
                        ))
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return _buildLoading(context);
  }
}
