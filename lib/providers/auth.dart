import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:florist/models/logging_interceptor.dart';
import 'package:http/http.dart' as http;

import 'package:florist/my_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_auth.dart';

class Auth with ChangeNotifier {
  static UserAuth? userAuth;
  String _userId = '';
  String _token = '';
  String _refreshToken = '';
  DateTime? _expiresIn;

  String get token {
    return _token;
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.https(
        'identitytoolkit.googleapis.com',
        "/v1/accounts:signUp",
        {"key": MyConstant.FIREBASE_PROJECT_WEB_API_KEY});

    final bodyJson = json.encode({
      "email": email,
      "password": password,
      "returnSecureToken": true,
    });

    final httpInter = InterceptedHttp.build(interceptors: [LoggingInterceptor()]);

    final response = await httpInter.post(url, body: bodyJson);
    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    print("responseBody > $responseBody");

    if (responseBody['error'] != null) {
      print(
          "responseBody['error']['message'] > ${responseBody['error']['message']}");
      throw (HttpException(responseBody['error']['message']));
    }
  }

  Future<void> signIn(String email, String password) async {
    final httpInter = InterceptedHttp.build(interceptors: [LoggingInterceptor()]);


    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      "/v1/accounts:signInWithPassword",
      {"key": MyConstant.FIREBASE_PROJECT_WEB_API_KEY},
    );

    final bodyJson = json.encode({
      "email": email,
      "password": password,
      "returnSecureToken": true,
    });

    final response = await httpInter.post(url, body: bodyJson);
    final responseBody = json.decode(response.body) as Map<String, dynamic>;

    _userId = responseBody['localId'];
    _token = responseBody['idToken'];
    userAuth = UserAuth(userId: _userId, token: _token);
    _expiresIn = DateTime.now()
        .add(Duration(seconds: int.parse(responseBody['expiresIn'])));
    _refreshToken = responseBody['refreshToken'];

    await saveAuthData();
    notifyListeners();
  }

  bool get isAuthenticated {
    if (_token.isEmpty) {
      return false;
    }

    if (DateTime.now().isAfter(_expiresIn ?? DateTime(2021))) {
      return false;
    }

    return true;
  }

  Future<void> saveAuthData() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    // Save an auth values to 'user_auth' key.
    await prefs.setString(
        'user_auth',
        json.encode({
          'user_id': _userId,
          'token': _token,
          'refresh_token': _refreshToken,
          'expires_in': _expiresIn?.toIso8601String(),
        }));
  }

  Future<void> fetchAuthData() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    final userAuthData = await prefs.getString('user_auth');
    final userAuthJson = json.decode(userAuthData!) as Map<String, dynamic>;

    _userId = userAuthJson['user_id'];
    _token = userAuthJson['token'];
    _refreshToken = userAuthJson['refresh_token'];
    _expiresIn = DateTime.parse(userAuthJson['expires_in']);

    notifyListeners();
  }
}
