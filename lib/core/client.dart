import 'package:dio/dio.dart';
import 'package:famili/constants/constants.dart';
import 'package:famili/core/data/user_prefs.dart';
import 'package:famili/injection.dart';

class Client {
  static Dio create({String baseUrl}) {
    final Dio client = Dio();
    client.options.baseUrl = baseUrl ??= Constant.baseApiUrl;
    client.interceptors.add(ClientInterceptor());
    client.interceptors.add(LogInterceptor());
    return client;
  }
}

class ClientInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    var userToken = await locator<UserPref>().getToken();
    if (userToken != null) {
      options.headers = {'Authorization': 'Bearer ${userToken.accessToken}'};
    }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }
}
