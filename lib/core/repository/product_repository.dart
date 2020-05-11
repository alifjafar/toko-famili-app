import 'package:dio/dio.dart';
import 'package:famili/core/client.dart';
import 'package:famili/core/data/response/product_collection.dart';
import 'package:famili/core/data/response/product_price_collection.dart';
import 'package:famili/core/data/response/product_response.dart';
import 'package:famili/core/exceptions/api_exception.dart';
import 'package:sprintf/sprintf.dart';

class ProductRepository{
  final Dio client = Client.create();

  Future<ProductCollection> getProducts(
      {String keywords = '', int limit = 6, int page}) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
        'keywords': keywords,
        'page': page
      };

      var response = await client.get(ProductConstant.getProduct,
          queryParameters: queryParams);
      return ProductCollection.fromJson(response.data);
    } on DioError catch (error) {
      throw ApiException.parseError(error);
    }
  }

  Future<ProductResponse> getProduct(String id) async {
    try {
      var response =
      await client.get(sprintf(ProductConstant.getSingle, [id]));
      print(response);
      return ProductResponse.fromJson(response.data);
    } on DioError catch (error) {
      throw ApiException.parseError(error);
    }
  }

  Future<ProductPriceCollection> getProductPrice(String id) async {
    try {
      var response =
      await client.get(sprintf(ProductConstant.getProductPrice, [id]));
      return ProductPriceCollection.fromJson(response.data);
    } on DioError catch (error) {
      throw ApiException.parseError(error);
    }
  }
}

class ProductConstant {
  static const String getProduct = "products";
  static const String getSingle = "products/%s";
  static const String getProductPrice = "products/%s/prices";
}