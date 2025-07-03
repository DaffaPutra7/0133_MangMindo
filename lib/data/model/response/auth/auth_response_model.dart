import 'dart:convert';

class AuthResponseModel {
  final String accessToken;
  final String tokenType;
  final String role;
  final User user;

  AuthResponseModel({
    required this.accessToken,
    required this.tokenType,
    required this.role,
    required this.user,
  });

  factory AuthResponseModel.fromMap(Map<String, dynamic> json) =>
      AuthResponseModel(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        role: json["role"],
        user: User.fromMap(json["user"]),
      );

  factory AuthResponseModel.fromJson(String str) =>
      AuthResponseModel.fromMap(json.decode(str));
}

// Model User untuk menampung data user dari respons
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
      );
}