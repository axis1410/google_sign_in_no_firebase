import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in_no_firebase/constants.dart';
import 'package:google_sign_in_no_firebase/providers/user_provider.dart';
import 'package:google_sign_in_no_firebase/services/auth_service.dart';
import "package:http/http.dart" as http;

class HomePage extends ConsumerStatefulWidget {
  final String accessToken;

  const HomePage({super.key, required this.accessToken});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();

    fetchMe(ref.read(userProvider).accessToken);
  }

  Future<void> fetchMe(String token) async {
    const url = "$apiUrl/me";

    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      final userNotifier = ref.read(userProvider.notifier);
      userNotifier.updateUserName(userData['user']["name"]);
      userNotifier.updateUserEmail(userData['user']["email"]);
    } else {
      print("Error");
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = ref.read(userProvider).accessToken;
    final userName = ref.read(userProvider).name;
    final email = ref.read(userProvider).email;

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home"),
      // ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Text(widget.accessToken),
              Text(
                "Hello $userName",
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Email: $email", style: const TextStyle(fontSize: 16)),
              ElevatedButton(
                child: const Text("Sign out"),
                onPressed: () {
                  AuthService.signOut(context, ref, token);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  context.go("/test");
                },
                child: const Text("Go to test page"),
              )
              // Text(accessToken),
            ],
          ),
        ),
      ),
    );
  }
}
