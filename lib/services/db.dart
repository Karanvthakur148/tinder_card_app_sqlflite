import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


class Db {
  static const String userIdKey = "userIdKey";
  static const String authTokenKey = "authTokenKey";

  static Future<bool> setUserId(String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(userIdKey, userId);
  }


  static Future<bool> setAuthToken(String authToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(authTokenKey, authToken);
  }


  static Future<String?> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString(userIdKey);
  }

  static Future<String?> getAuthToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    return preferences.getString(authTokenKey);
  }


}
