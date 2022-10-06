import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class AuthScreen extends StatelessWidget {
  static const screenName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

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
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
              ),
              ElevatedButton(
                onPressed: () {
                  authProvider.signUp(
                    emailController.text,
                    passwordController.text,
                  );
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
              authProvider.isAuthenticated()
                  ? Text('Authenticated')
                  : Text('Not Authenticated')
            ],
          ),
        ),
      ),
    );
  }
}
