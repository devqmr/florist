import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/logging_interceptor.dart';
import '../models/user_auth.dart';
import '../my_constant.dart';
import '../utils/help_utils.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial(""));

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

    signIn(email, password);
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

    if (responseBody['error'] != null) {
      print(
          "responseBody['error']['message'] > ${responseBody['error']['message']}");
      throw (HttpException(responseBody['error']['message']));
    }

    _userId = responseBody['localId'];
    _token = responseBody['idToken'];
    userAuth = UserAuth(userId: _userId, token: _token);
    _expiresIn = DateTime.now()
        .add(Duration(seconds: int.parse(responseBody['expiresIn'])));
    _refreshToken = responseBody['refreshToken'];

    await saveAuthData();
    // notifyListeners(); todo
    emit(AuthSignInSuccess(""));
  }

  Future<bool> tryAutoSignIn() async {
    HelpUtils.logger.d("[AuthState >> FutureBuilder  enter tryAutoSignIn()]");

    final isHaveData = await fetchAuthData();
    if (!isHaveData) {
      return false;
    }

    if (isAuthenticated) {
      // notifyListeners(); todo
      emit(AuthSignInSuccess(""));
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
    emit(AuthSignOutSuccess(""));
  }

  Future<void> clearAuthData() async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    // Save an auth values to 'user_auth' key.
    await prefs.clear();
  }
}
