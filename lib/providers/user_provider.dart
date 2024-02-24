import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in_no_firebase/models/user_model.dart';

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});
