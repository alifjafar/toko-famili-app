import 'package:dio/dio.dart';
import 'package:famili/core/exceptions/api_exception.dart';
import 'package:rxdart/rxdart.dart';

void rxApi<T>(
    {Future<dynamic> repository,
    Subject<T> subject,
    bool clear = false}) async {
  try {
    if (clear) {
      subject.sink.add(null);
    } else {
      _checkSubjectValue(subject);
    }
    var response = await repository;
    subject.sink.add(response as T);
  } on ApiException catch (err) {
    subject.sink.addError(err.errorResponse.errors.single.message.single);
  } on DioError catch (err) {
    subject.sink.addError(err.error);
  }
}

void _checkSubjectValue(dynamic subject) {
  if (subject is BehaviorSubject && subject.hasValue) {
    subject.sink.add(null);
  }
}
