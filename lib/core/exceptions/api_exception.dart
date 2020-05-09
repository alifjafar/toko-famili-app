import 'package:dio/dio.dart';
import 'package:famili/core/data/response/base_error_response.dart';

class ApiException implements Exception {

  final BaseErrorResponse errorResponse;

  ApiException(this.errorResponse);


  String toString() => "ApiException";

  static DioError parseError(DioError error) {
    if (error.type == DioErrorType.RESPONSE)
      throw ApiException(
          BaseErrorResponse.fromJson(error.response.data));
    throw error;
  }
}