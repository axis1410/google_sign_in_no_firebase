import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in_no_firebase/providers/user_provider.dart';
import 'package:google_sign_in_no_firebase/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  void initState() {
    super.initState();

    getDataFromPrefs().then((value) {
      if (value) {
        ref.read(userProvider.notifier).updateUserAccessToken("");
        context.go("/landing");
      }
    });
  }

  Future<bool> getDataFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(AuthService.isLoggedInKey) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login Page"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  AuthService.signIn(context, ref);
                },
                child: const Text("Login with google"),
              )
            ],
          ),
        ));
  }
}
