


import 'package:famili/components/product/product_item.dart';
import 'package:famili/core/data/models/product.dart';
import 'package:famili/core/data/response/product_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  final ProductCollection productList;

  ProductGrid(this.productList);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    var gridAspectRatio = mediaQuery.size.height > 750 ? 0.9 : 0.8;
    return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: gridAspectRatio,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        children: List.generate(productList.data.length, (index) {
          Product product = productList.data[index];
          return ProductItem(
            product: product,
          );
        }));
  }
}
