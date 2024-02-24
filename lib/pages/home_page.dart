import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in_no_firebase/providers/user_provider.dart';
import 'package:google_sign_in_no_firebase/services/auth_service.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmail = ref.watch(
      userProvider.select((value) => value.email),
    );
    final username = ref.watch(
      userProvider.select((value) => value.name),
    );
    final accessToken = ref.watch(
      userProvider.select((value) => value.accessToken),
    );
    final refreshToken = ref.watch(
      userProvider.select((value) => value.refreshToken),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter google sign in"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(username),
            Text(userEmail),
            Text(accessToken),
            const SizedBox(height: 20),
            Text(refreshToken),
            ElevatedButton(
              onPressed: () => AuthService.signIn(context, ref),
              child: const Text("Sign in with google"),
            ),
            ElevatedButton(
              onPressed: () => AuthService.signOut(context, ref, accessToken),
              child: const Text("Logout"),
            ),
            ElevatedButton(
              onPressed: () =>
                  AuthService.getNewAccessToken(ref, accessToken, refreshToken),
              child: const Text("Get new access token"),
            )
          ],
        ),
      ),
    );
  }
}
