import 'package:famili/components/loading.dart';
import 'package:famili/components/product/product_item.dart';
import 'package:famili/core/data/models/product.dart';
import 'package:famili/core/data/response/product_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductGrid extends StatelessWidget {
  final ProductPaginate productList;

  ProductGrid(this.productList);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StaggeredGridView.countBuilder(
          shrinkWrap: true,
          crossAxisCount: 2,
          physics: NeverScrollableScrollPhysics(),
          itemCount: productList.data.length,
          itemBuilder: (context, index) =>
              LayoutBuilder(builder: (context, size) {
            final span = TextSpan(text: productList.data[index].name);
            final tp = TextPainter(
                text: span,
                textAlign: TextAlign.start,
                maxLines: 1,
                textDirection: TextDirection.ltr);
            tp.layout(maxWidth: size.maxWidth / 1.8);
            return Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 20.0,
                  color: Colors.black.withOpacity(.2),
                  spreadRadius: -20,
                ),
              ], borderRadius: BorderRadius.circular(12.0)),
              height: tp.didExceedMaxLines ? 240 : 220,
              child: ProductItem(product: productList.data[index]),
            );
          }),
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          crossAxisSpacing: 2,
          mainAxisSpacing: 10,
        ),
        Visibility(
          visible: productList.isLoading,
          child: circularLoading(),
        ),
        Visibility(
          visible: productList.isLoading,
          child: SizedBox(height: 50),
        )
      ],
    );
  }
}
