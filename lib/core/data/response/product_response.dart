import 'package:famili/core/data/models/meta.dart';
import 'package:famili/core/data/models/product.dart';

import 'base_response.dart';

class ProductResponse extends BaseResponse {
  Product data;

  ProductResponse({String message, this.data, Meta meta}) : super(message, meta);

  ProductResponse.fromJson(Map<String, dynamic> json)
      : data = Product.fromJson(json['data']),
        super.fromJson(json);
}