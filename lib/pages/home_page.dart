import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in_no_firebase/services/auth_service.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.accessToken),
            ElevatedButton(
              child: const Text("Sign out"),
              onPressed: () {
                AuthService.signOut(context, ref, widget.accessToken);
              },
            ),
            // Text(accessToken),
          ],
        ),
      ),
    );
  }
}
