import 'package:go_router/go_router.dart';
import 'package:google_sign_in_no_firebase/pages/home_page.dart';
import 'package:google_sign_in_no_firebase/pages/landing_page.dart';
import 'package:google_sign_in_no_firebase/pages/login_page.dart';

final router = GoRouter(
  initialLocation: "/landing",
  routes: [
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: "/home",
      builder: (context, state) {
        final accessToken = state.uri.queryParameters["accessToken"] ?? "";

        return HomePage(accessToken: accessToken);
      },
    ),
    GoRoute(
      path: "/landing",
      builder: (context, state) => const LandingPage(),
    ),
  ],
);
