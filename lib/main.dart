import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:google_sign_in_no_firebase/api/google_signin_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  static const apiUrl = "http://172.20.10.4:8080";
  Map<String, String> loggedInUser = {};

  Future<void> sendData(String name, String email) async {
    const url = "$apiUrl/login";

    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      print('Data sent successfully');
    } else {
      print('Failed to send data');
    }
  }

  Future<void> sendLogout(Map<String, String> user) async {
    const url = "$apiUrl/logout";

    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        'name': user['name'].toString(),
        'email': user['email'].toString(),
      }),
    );

    if (response.statusCode == 200) {
      print('Data sent successfully');
    } else {
      print('Failed to send data');
    }
  }

  Future signIn() async {
    final user = await GoogleSigninApi.login();

    loggedInUser = {
      "name": user!.displayName.toString(),
      "email": user.email.toString()
    };

    sendData(user.displayName.toString(), user.email.toString());
  }

  Future signOut() async {
    await GoogleSigninApi.logout();

    sendLogout(loggedInUser);
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
          child: Column(
            children: [
              ElevatedButton(
                onPressed: signIn,
                child: const Text("Sign in with google"),
              ),
              ElevatedButton(onPressed: signOut, child: const Text("Logout"))
            ],
          ),
        ),
      ),
    );
  }
}
