import 'package:famili/core/data/models/meta.dart';
import 'package:famili/core/data/models/product_price.dart';
import 'base_response.dart';

class ProductPriceCollection extends BaseResponse {
  List<ProductPrice> data;

  ProductPriceCollection({String message, this.data, Meta meta})
      : super(message, meta);

  ProductPriceCollection.fromJson(Map<String, dynamic> json)
      : data = (json["data"] as List)
      .map((item) => ProductPrice.fromJson(item))
      .toList(),
        super.fromJson(json);
}

