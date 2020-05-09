import '../models/meta.dart';

class BaseResponse {
  String message;
  Meta meta;

  BaseResponse(this.message, this.meta);

  BaseResponse.fromJson(Map<String, dynamic> json)
    : message = json['message'],
      meta = Meta.fromJson(json['meta']);
}