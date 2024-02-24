// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in_no_firebase/providers/user_provider.dart';
import 'package:http/http.dart' as http;

import 'package:google_sign_in_no_firebase/api/google_signin_api.dart';
import 'package:google_sign_in_no_firebase/models/user_model.dart';
import 'package:google_sign_in_no_firebase/shared/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const apiUrl = "http://172.20.10.4:8080";
  // static const apiUrl = "http://172.20.10.3:8080";

  static const String _isSignedInKey = "_isSIgnedIn";

  static const loginUrl = "$apiUrl/login";
  static const logoutUrl = "$apiUrl/logout";

  static Future<void> signIn(BuildContext context, WidgetRef ref) async {
    final googleUser = await GoogleSigninApi.login();

    var response = await http.post(
      Uri.parse(loginUrl),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode({
        "name": googleUser!.displayName.toString(),
        "email": googleUser.email.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      final userNotifier = ref.read(userProvider.notifier);
      // userNotifier.updateUser(User.fromMap(userData["user"]));
      // print(userData);
      userNotifier.updateUserName(userData['user']["name"]);
      userNotifier.updateUserEmail(userData['user']["email"]);
      userNotifier.updateUserAccessToken(userData["access_token"]);
      userNotifier.updateUserRefreshToken(userData["refresh_token"]);

      await storage.write(
        key: "access_token",
        value: userData["access_token"],
      );
      await storage.write(
        key: "refresh_token",
        value: userData["refresh_token"],
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool(_isSignedInKey, true);

      context.go("/home");
    } else {
      print("Failed to login");
      print(response.statusCode);
    }
  }

  static Future<void> signOut(
    BuildContext context,
    WidgetRef ref,
    String accessToken,
  ) async {
    await GoogleSigninApi.logout();
    // sendLogout(ref);

    var response = await http.post(
      Uri.parse(logoutUrl),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        "Authorization": "Bearer $accessToken"
      },
      // TODO: Change logout functionality to use the accesstoken and not the body
      body: jsonEncode(<String, String>{
        'name': ref.watch(userProvider).name.toString(),
        'email': ref.watch(userProvider).email.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final userNotifier = ref.read(userProvider.notifier);
      userNotifier.updateUser(User(
        id: 0,
        name: "",
        email: "",
        accessToken: "",
        refreshToken: "",
      ));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isSignedInKey, false);

      context.go("/login");
    } else {
      print("Failed to logout");
      print(response.statusCode);
    }
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_isSignedInKey) ?? false;
  }

  static Future<String> getNewAccessToken(
    WidgetRef ref,
    String accessToken,
    String refreshToken,
  ) async {
    const url = "$apiUrl/token";

    Map<String, String> tokens = {
      "accessToken": accessToken.toString(),
      "refreshToken": refreshToken.toString()
    };

    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken"
      },
      encoding: Encoding.getByName("utf-8"),
    );

    // print(accessToken);
    // print("response.body: ${response.body}");

    if (response.statusCode == 200) {
      // print(response.body);
      final userData = json.decode(response.body);
      final userNotifier = ref.read(userProvider.notifier);
      userNotifier.updateUserAccessToken(userData["access_token"]);
      return userData["access_token"];
    } else {
      print("failed to get token ${response.statusCode}");
      return "";
    }
  }
}
