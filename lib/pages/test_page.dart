import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in_no_firebase/constants.dart';
import 'package:google_sign_in_no_firebase/providers/user_provider.dart';
import "package:http/http.dart" as http;

class TestPage extends ConsumerWidget {
  const TestPage({super.key});

  void sendTestRequest(String token) async {
    const url = "$apiUrl/test/hello";

    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print("Error");
      print(response.statusCode);
      // print(response.body);
    }
  }

  void tokenRequest(String token) async {
    const url = "$apiUrl/me";

    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $token"
      },
      // body: jsonEncode({}),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(userProvider).accessToken;

    // print(token);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Page"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                sendTestRequest(token);
              },
              child: const Text("Send Test request"),
            ),
            ElevatedButton(
              onPressed: () {
                context.go("/home");
              },
              child: const Text("Go home"),
            ),
            ElevatedButton(
              onPressed: () => tokenRequest(token),
              child: const Text("Token Request"),
            )
          ],
        ),
      ),
    );
  }
}
