import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninApi {
  static final List<String> scopes = <String>[
    "email",
    "https://www.googleapis.com/auth/userinfo.profile",
  ];

  static final _googleSignIn = GoogleSignIn(
    scopes: scopes,
    signInOption: SignInOption.standard,
  );

  static Future<GoogleSignInAccount?> login() {
    return _googleSignIn.signIn();
  }

  static Future logout() => _googleSignIn.disconnect();
}


// keytool -genkey -v -keystore %userprofile%\mykey.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias androiddebugkey