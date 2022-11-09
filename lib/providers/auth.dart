import 'dart:convert';
import 'dart:io';
import 'package:florist/models/logging_interceptor.dart';

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
  final interceptedHttp =
  InterceptedHttp.build(interceptors: [LoggingInterceptor()]);

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



    final response = await interceptedHttp.post(url, body: bodyJson);
    final responseBody = json.decode(response.body) as Map<String, dynamic>;
    print("responseBody > $responseBody");

    if (responseBody['error'] != null) {
      print(
          "responseBody['error']['message'] > ${responseBody['error']['message']}");
      throw (HttpException(responseBody['error']['message']));
    }
  }

  Future<void> signIn(String email, String password) async {

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

    final response = await interceptedHttp.post(url, body: bodyJson);
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

  Future<bool> tryAutoSignIn() async {
    final isHaveData = await fetchAuthData();
    if (!isHaveData) {
      return false;
    }

    if(isAuthenticated){
      notifyListeners();
      return true;
    }




    return false;
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

  Future<bool> fetchAuthData() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 5));

    if (!prefs.containsKey('user_auth')) {
      return false;
    }

    final userAuthData = await prefs.getString('user_auth');
    final userAuthJson = json.decode(userAuthData!) as Map<String, dynamic>;

    _userId = userAuthJson['user_id'];
    _token = userAuthJson['token'];
    _refreshToken = userAuthJson['refresh_token'];
    _expiresIn = DateTime.parse(userAuthJson['expires_in']);
    userAuth = UserAuth(userId: _userId, token: _token);


    return true;
  }

  Future<void> logout() async {
    userAuth = null;
    _userId = '';
    _token = '';
    _refreshToken = '';
    _expiresIn = null;

    await clearAuthData();
    notifyListeners();
  }

  Future<void> clearAuthData() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    // Save an auth values to 'user_auth' key.
    await prefs.clear();
  }
}
