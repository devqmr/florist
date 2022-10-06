import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

import 'package:florist/my_constant.dart';
import 'package:flutter/foundation.dart';

class Auth with ChangeNotifier {
  String _userId = '';
  String _token = '';
  String _refreshToken = '';
  DateTime? _expiresIn;

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

    final response = await http.post(url, body: bodyJson);
    final responseBody = json.decode(response.body) as Map<String, dynamic>;
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

    final response = await http.post(url, body: bodyJson);
    final responseBody = json.decode(response.body) as Map<String, dynamic>;

    _userId = responseBody['localId'];
    _token = responseBody['idToken'];

    _expiresIn = DateTime.now()
        .add(Duration(seconds: int.parse(responseBody['expiresIn'])));
    _refreshToken = responseBody['refreshToken'];

    notifyListeners();
  }

  bool isAuthenticated() {
    if (_token.isEmpty) {
      return false;
    }

    if (DateTime.now().isAfter(_expiresIn ?? DateTime(2021))) {
      return false;
    }

    return true;
  }
}
