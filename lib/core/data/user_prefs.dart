import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user_token.dart';

class ConstantPref {
  static final String token = "user_token";
  static final String isLogged = "is_logged";
}

class UserPref {
  static UserPref _instance;
  static SharedPreferences prefs;

  static Future<UserPref> getInstance() async {
    if (_instance == null) {
      _instance = UserPref();
    }
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  Future<void> saveToken(UserToken token) async {
    await prefs.setString(ConstantPref.token, json.encode(token.toJson()));
    await prefs.setBool(ConstantPref.isLogged, true);
  }

//  Future<void> saveUser(User user) async {
//    final prefs = await SharedPreferences.getInstance();
//    await prefs.setString(PreferenceName.user, json.encode(user.toJson()));
//  }

  Future<bool> isLogged() async {
    return prefs.getBool(ConstantPref.isLogged) ?? false;
  }

  Future<UserToken> getToken() async {
    String userToken = prefs.getString(ConstantPref.token);
    if (userToken == null) {
      return null;
    }

    return UserToken.fromJson(json.decode(userToken));
  }
}
