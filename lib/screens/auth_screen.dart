import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:florist/app_style.dart';
import 'package:florist/clip_paths/WaveClipper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class AuthScreen extends StatefulWidget {
  static const screenName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isNeedToCreateAccount = false;
  bool _isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);


    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Image.asset(
                'assets/images/login_bg.jpg',
                fit: BoxFit.cover,
                width: double.maxFinite,
                height: 450,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 0),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _isNeedToCreateAccount ? 'Create Account' : 'Login',
                      style: AppStyle.appFontBold
                          .copyWith(fontSize: 40, color: Colors.purple[600]),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFF8E24AA).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10))
                          ]),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[200]!))),
                            child: TextField(
                              decoration: const InputDecoration(
                                  hintText: "Enter Your Email",
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey)),
                              controller: emailController,
                              // ..text = 'ahmed02@gmail.com',
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: _isNeedToCreateAccount
                                ? BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey[200]!)))
                                : null,
                            child: TextField(
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey)),
                              controller: passwordController,
                              // ..text = '123456',
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                            ),
                          ),
                          if (_isNeedToCreateAccount)
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Confirm Your Password",
                                    hintStyle: TextStyle(color: Colors.grey)),
                                controller: confirmPasswordController,
                                // ..text = '123456',
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    _isNeedToCreateAccount
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            height: 50,
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: () {
                                signUp(
                                    authProvider,
                                    emailController,
                                    passwordController,
                                    confirmPasswordController);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Create Account',
                                    ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            height: 50,
                            width: double.maxFinite,
                            child: ElevatedButton(
                              onPressed: () {
                                signIn(authProvider, emailController,
                                    passwordController);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Login',
                                    ),
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    _isNeedToCreateAccount
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                _isNeedToCreateAccount = false;
                              });
                            },
                            child: const Text('I have account'))
                        : TextButton(
                            onPressed: () {
                              setState(() {
                                _isNeedToCreateAccount = true;
                              });
                            },
                            child: const Text('Create account'))
                    // ElevatedButton(
                    //   onPressed: () {
                    //     authProvider.fetchAuthData();
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     shape: const StadiumBorder(),
                    //   ),
                    //   child: const Text(
                    //     'Check Sign-In from local data',
                    //   ),
                    // ),
                    // authProvider.isAuthenticated
                    //     ? Text('Authenticated')
                    //     : Text('Not Authenticated')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signIn(Auth authProvider, TextEditingController emailController,
      TextEditingController passwordController) async {
    try {
      if (emailController.text.isEmpty) {
        showWarningMessage("Enter the email");
        return;
      }

      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text);

      if (!emailValid) {
        showWarningMessage("Enter valid email");
        return;
      }

      if (passwordController.text.isEmpty) {
        showWarningMessage("Enter the password");
        return;
      }

      showLoading();

      await authProvider.signIn(
        emailController.text,
        passwordController.text,
      );
    } on HttpException catch (error) {
      if (error.message.contains('EMAIL_EXISTS')) {
        print(
            'This email is already used please used another one, or go to sign in ');
        showErrorMessage('This email is already used');
      }

      if (error.message.contains('EMAIL_NOT_FOUND')) {
        print(
            'This email is not found used please used another one, or go to create new account ');
        showErrorMessage('This email is not found');
      }

      if (error.message.contains('INVALID_PASSWORD')) {
        print(
            'This email is not found used please used another one, or go to create new account ');
        showErrorMessage('Verify the entered email and password');
      }
    } catch (e) {
      print(e);
      print('Try again');
    } finally {
      hideLoading();
    }
  }

  void signUp(
      Auth authProvider,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController) async {
    try {
      if (emailController.text.isEmpty) {
        showWarningMessage("Enter the email");
        return;
      }

      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text);

      if (!emailValid) {
        showWarningMessage("Enter valid email");
        return;
      }

      if (passwordController.text.isEmpty) {
        showWarningMessage("Enter the password");
        return;
      }

      if (passwordController.text.trim().length < 6) {
        showWarningMessage("Password should be at least 6 characters");
        return;
      }

      if (confirmPasswordController.text.isEmpty) {
        showWarningMessage("Enter the confirm password");
        return;
      }

      if (passwordController.text != confirmPasswordController.text) {
        showWarningMessage("Password and confirm password are not match");
        return;
      }

      showLoading();
      await authProvider.signUp(
        emailController.text,
        passwordController.text,
      );
    } on HttpException catch (error) {
      if (error.message.contains('EMAIL_EXISTS')) {
        print(
            'This email is already used please used another one, or go to sign in ');
        showErrorMessage('This email is already used');
      }
    } catch (e) {
      print(e);
      print('Try again');
    } finally {
      hideLoading();
    }
  }

  void showErrorMessage(String errorMessage) {
    final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
            title: "Error!",
            message: errorMessage,
            contentType: ContentType.failure));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showWarningMessage(String errorMessage) {
    final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
            title: "Need Info!",
            message: errorMessage,
            contentType: ContentType.warning));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
