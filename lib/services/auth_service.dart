// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in_no_firebase/constants.dart';
import 'package:google_sign_in_no_firebase/providers/user_provider.dart';
import 'package:http/http.dart' as http;

import 'package:google_sign_in_no_firebase/api/google_signin_api.dart';
import 'package:google_sign_in_no_firebase/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String access_token = "";
  static const String _isLoggedInKey = 'isLoggedIn';

  static const loginUrl = "$apiUrl/login";
  static const logoutUrl = "$apiUrl/logout";

  static String get isLoggedInKey => _isLoggedInKey;

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

      print(ref.read(userProvider).accessToken);
      print(ref.read(userProvider).email);
      print(ref.read(userProvider).name);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString(access_token, userData["access_token"]);
      await prefs.setBool(_isLoggedInKey, true);

      context.go("/landing");
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
      body: jsonEncode({}),
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

      await prefs.remove(accessToken);
      await prefs.setBool(_isLoggedInKey, false);
      await prefs.remove("user_name");

      context.go("/login");
    } else {
      print("Failed to logout");
      print(response.statusCode);
    }
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // return prefs.getBool(_isSignedInKey) ?? false;
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<String> getNewAccessToken(
    WidgetRef ref,
    String accessToken,
    String refreshToken,
  ) async {
    const url = "$apiUrl/token";

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

      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString("access_token", userData["access_token"]);
      await prefs.setBool(_isLoggedInKey, true);

      return userData["access_token"];
    } else {
      print("failed to get token ${response.statusCode}");
      return "";
    }
  }
}
