import 'dart:convert';

import 'package:google_sign_in_no_firebase/models/user_model.dart';

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  AuthResponse copyWith({
    String? accessToken,
    String? refreshToken,
    User? user,
  }) {
    return AuthResponse(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'accessToken': accessToken});
    result.addAll({'refreshToken': refreshToken});
    result.addAll({'user': user.toMap()});

    return result;
  }

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
      user: User.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromJson(String source) =>
      AuthResponse.fromMap(json.decode(source));

  @override
  String toString() =>
      'AuthResponse(accessToken: $accessToken, refreshToken: $refreshToken, user: $user)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthResponse &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.user == user;
  }

  @override
  int get hashCode =>
      accessToken.hashCode ^ refreshToken.hashCode ^ user.hashCode;
}
