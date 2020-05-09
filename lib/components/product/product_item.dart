import 'package:famili/constants/colors.dart';
import 'package:famili/core/data/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../image_item.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({this.product});

  @override
  Widget build(BuildContext context) {
    double imageHeight = 130.00;
    return Card(
        elevation: 2,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
        child: GestureDetector(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: ImageItem(
                  url: product.images[0]?.url,
                  height: imageHeight,
                )),
                Container(
                    margin: EdgeInsets.only(right: 12.0, left: 12.0,  top: 8.0),
                    child: Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    )),
                Container(
                  margin: EdgeInsets.only(right: 12.0, left: 12.0, top: 6.0),
                  child: Text(
                    "Rp ${product.price.priceFormat} / ${product.price.unit}",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: ColorBase.redOrange,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            onTap: null));
  }
}
