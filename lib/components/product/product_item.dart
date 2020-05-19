import 'package:famili/constants/colors.dart';
import 'package:famili/constants/navigation.dart';
import 'package:famili/core/data/models/product.dart';
import 'package:famili/core/navigation_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../injection.dart';
import '../image_item.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({this.product});

  @override
  Widget build(BuildContext context) {
    double imageHeight = 120.00;
    return Card(
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
                  margin: EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
                  child: Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  )),
              Container(
                margin: EdgeInsets.only(
                    right: 8.0, left: 8.0, top: 6.0, bottom: 30.0),
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
          onTap: () => locator<NavigationService>().navigateTo(
              NavigationConstant.ProductDetail,
              arguments: {'id': product.id, 'product': product}),
        ));
  }
}
