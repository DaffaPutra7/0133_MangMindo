import 'dart:convert';

class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final double? latitude;
  final double? longitude;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      if (latitude != null) 'latitude': latitude.toString(),
      if (longitude != null) 'longitude': longitude.toString(),
    };
  }

  String toJson() => json.encode(toMap());
}