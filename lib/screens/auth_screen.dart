import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
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
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SingUp or SignIn',
              ),
              TextField(
                decoration: const InputDecoration(hintText: "Enter Your Email"),
                controller: emailController..text = 'ahmed02@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                decoration:
                    const InputDecoration(hintText: "Enter Your Password"),
                controller: passwordController..text = '123456',
                keyboardType: TextInputType.visiblePassword,
              ),
              TextField(
                decoration:
                    const InputDecoration(hintText: "Confirm Your Password"),
                controller: confirmPasswordController..text = '123456',
                keyboardType: TextInputType.visiblePassword,
              ),
              ElevatedButton(
                onPressed: () {
                  signUp(authProvider, emailController, passwordController);
                },
                child: Text(
                  'Signup',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  authProvider.signIn(
                    emailController.text,
                    passwordController.text,
                  );
                },
                child: const Text(
                  'SignIn',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  authProvider.fetchAuthData();
                },
                child: const Text(
                  'Check Sign-In from local data',
                ),
              ),
              authProvider.isAuthenticated
                  ? Text('Authenticated')
                  : Text('Not Authenticated')
            ],
          ),
        ),
      ),
    );
  }

  void signUp(Auth authProvider, TextEditingController emailController,
      TextEditingController passwordController) async{
    try {
      await authProvider.signUp(
        emailController.text,
        passwordController.text,
      );
    } on HttpException catch (error) {
      if (error.message.contains('EMAIL_EXISTS')) {
        print(
            'This email is already used please used another one, or go to sign in ');
        showErrorMessage(
            'This email is already used');
      }
    } catch (e) {
      print(e);
      print('Try again');
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
}
