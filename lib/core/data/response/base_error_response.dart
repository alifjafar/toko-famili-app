
class BaseErrorResponse {
  List<ErrorItem> errors;
  Map<String, dynamic> meta;

  BaseErrorResponse(this.errors, this.meta);

  BaseErrorResponse.fromJson(Map<String, dynamic> json)
    : errors = List<ErrorItem>.from(json['errors'].map((item) => ErrorItem.fromJson(item))),
      meta = json['meta'];
}


class ErrorItem {
  String attribute;
  List<dynamic> message;

  ErrorItem({this.attribute, this.message});

  ErrorItem.fromJson(Map<String, dynamic> json)
    : attribute = json['attribute'] ??= null,
      message = json['message'] as List;
}