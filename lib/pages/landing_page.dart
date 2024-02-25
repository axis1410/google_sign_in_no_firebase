import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in_no_firebase/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in_no_firebase/services/auth_service.dart'; // Import your AuthService

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  @override
  void initState() {
    super.initState();

    getPrefsData(ref);
  }

  String _accessToken = "";
  bool _isLoggedIn = false;

  void getPrefsData(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(prefs.getString(AuthService.access_token));

    setState(() {
      _accessToken = prefs.getString(AuthService.access_token) ?? "";
      _isLoggedIn = prefs.getBool(AuthService.isLoggedInKey) ?? false;
    });

    ref.read(userProvider.notifier).updateUserAccessToken(_accessToken);

    print("Token from userProvider");
    print(ref.watch(userProvider.select((value) => value.accessToken)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Landing Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_isLoggedIn) {
                  context.go(Uri(
                          path: "/home",
                          queryParameters: {"accessToken": _accessToken})
                      .toString());
                } else {
                  context.go("/login");
                }
              },
              child: Text(
                (_isLoggedIn == true) ? "Go to Home" : "Go to login page",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
