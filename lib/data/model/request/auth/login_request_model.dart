import 'dart:convert';

class LoginRequestModel {
    final String email;
    final String password;

    LoginRequestModel({
        required this.email,
        required this.password,
    });

    Map<String, dynamic> toMap() => {
        "email": email,
        "password": password,
    };

    String toJson() => json.encode(toMap());
}