import 'base_error_response.dart';

class ValidationResponse extends BaseErrorResponse{
  ValidationResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}