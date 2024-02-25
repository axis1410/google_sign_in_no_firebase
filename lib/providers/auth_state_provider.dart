import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isSignedIn;
  final String accessToken;

  AuthState({
    required this.isSignedIn,
    required this.accessToken,
  });

  AuthState copyWith({
    bool? isSignedIn,
    String? accessToken,
  }) {
    return AuthState(
      isSignedIn: isSignedIn ?? this.isSignedIn,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'isSignedIn': isSignedIn});
    result.addAll({'accessToken': accessToken});

    return result;
  }

  factory AuthState.fromMap(Map<String, dynamic> map) {
    return AuthState(
      isSignedIn: map['isSignedIn'] ?? false,
      accessToken: map['accessToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthState.fromJson(String source) =>
      AuthState.fromMap(json.decode(source));

  @override
  String toString() =>
      'AuthState(isSignedIn: $isSignedIn, accessToken: $accessToken)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.isSignedIn == isSignedIn &&
        other.accessToken == accessToken;
  }

  @override
  int get hashCode => isSignedIn.hashCode ^ accessToken.hashCode;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isSignedIn: false, accessToken: ''));

  void updateAccessToken(String token) {
    state = state.copyWith(accessToken: token);
  }

  void updateAuthState(bool isSignedIn) {
    state = state.copyWith(isSignedIn: isSignedIn);
  }
}
