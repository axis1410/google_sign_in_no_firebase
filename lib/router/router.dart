import 'package:go_router/go_router.dart';
import 'package:google_sign_in_no_firebase/pages/home_page.dart';
import 'package:google_sign_in_no_firebase/pages/login_page.dart';

final router = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(
      path: "/login",
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
    )
  ],
);
