import 'package:famili/core/data/models/meta.dart';
import 'package:famili/core/data/models/product.dart';
import 'base_response.dart';

class ProductCollection extends BaseResponse {
  List<Product> data;

  ProductCollection({String message, this.data, Meta meta})
      : super(message, meta);

  ProductCollection.fromJson(Map<String, dynamic> json)
      : data = (json["data"] as List)
      .map((item) => Product.fromJson(item))
      .toList(),
        super.fromJson(json);
}