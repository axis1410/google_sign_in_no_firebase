import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_no_firebase/api/google_signin_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future signIn() async {
    await GoogleSigninApi.login();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter google sign in"),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: signIn,
            child: const Text("Sign in with google"),
          ),
        ),
      ),
    );
  }
}
