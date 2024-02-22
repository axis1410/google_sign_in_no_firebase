import 'package:google_sign_in/google_sign_in.dart';

class GoogleSigninApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
}


// keytool -genkey -v -keystore %userprofile%\mykey.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias androiddebugkey