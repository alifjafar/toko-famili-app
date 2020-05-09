import 'package:dio/dio.dart';
import 'package:famili/core/client.dart';
import 'package:famili/core/data/response/product_collection.dart';
import 'package:famili/core/exceptions/api_exception.dart';

class ProductRepository{
  final Dio client = Client.create();

  Future<ProductCollection> getProducts(
      {String keywords = '', int limit = 30}) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
        'keywords': keywords
      };

      var response = await client.get(ProductConstant.getProduct,
          queryParameters: queryParams);
      return ProductCollection.fromJson(response.data);
    } on DioError catch (error) {
      throw ApiException.parseError(error);
    }
  }
}

class ProductConstant {
  static const String getProduct = "products";
}