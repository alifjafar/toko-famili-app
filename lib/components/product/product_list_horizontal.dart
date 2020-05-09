import 'package:famili/components/product/product_item.dart';
import 'package:famili/constants/colors.dart';
import 'package:famili/constants/constants.dart';
import 'package:famili/core/data/models/product.dart';
import 'package:famili/core/data/response/product_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductListHorizontalItem extends StatelessWidget {
  final ProductCollection productList;
  final String title;
  final bool withVendorInfo;
  final Function onTap;

  ProductListHorizontalItem(this.productList, this.title,
      {this.withVendorInfo = false, this.onTap});

  Widget listProductWidget(ProductCollection productList, String title) {
    double height = withVendorInfo ? 215.0 : 200.0;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 6.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: ColorBase.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  InkWell(
                      onTap: onTap,
                      child: Text(
                        Constant.viewAll,
                        style: TextStyle(
                            color: ColorBase.primary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0),
                      ))
                ]),
          ),
          Container(
              height: height,
              child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: productList.data.length,
                  itemBuilder: (context, index) {
                    Product product = productList.data[index];
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
                      child: ProductItem(
                        product: product,
                      ),
                    );
                  }))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return listProductWidget(productList, title);
  }
}