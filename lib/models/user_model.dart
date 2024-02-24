import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String accessToken;
  final String refreshToken;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? accessToken,
    String? refreshToken,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'accessToken': accessToken});
    result.addAll({'refreshToken': refreshToken});

    return result;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      accessToken: map['accessToken'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, accessToken: $accessToken, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        accessToken.hashCode ^
        refreshToken.hashCode;
  }
}

class UserNotifier extends StateNotifier<User> {
  UserNotifier()
      : super(
          User(
            id: 0,
            name: "",
            email: "",
            accessToken: "",
            refreshToken: "",
          ),
        );

  void updateUserName(String name) {
    state = state.copyWith(name: name);
  }

  void updateUserEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateUserAccessToken(String accessToken) {
    state = state.copyWith(accessToken: accessToken);
  }

  void updateUserRefreshToken(String refreshToken) {
    state = state.copyWith(refreshToken: refreshToken);
  }

  void updateUser(User user) {
    state = user;
  }
}
