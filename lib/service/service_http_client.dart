import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ServiceHttpClient {
  // baseUrl untuk koneksi dari emulator Android ke localhost
  final String baseUrl = 'http://10.0.2.2:8000/api';
  final _secureStorage = const FlutterSecureStorage();

  // Method POST
  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final token = await _secureStorage.read(key: 'auth_token');

    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }

  // Method GET
  Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final token = await _secureStorage.read(key: 'auth_token');

    return await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  // Method POST dengan file
  Future<http.Response> postWithFile(
    String endpoint,
    Map<String, String> body,
    XFile? file,
  ) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final token = await _secureStorage.read(key: 'auth_token');

    var request = http.MultipartRequest('POST', url);

    // Tambahkan header
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['Accept'] = 'application/json';

    // Tambahkan data teks
    request.fields.addAll(body);

    // Tambahkan file gambar jika ada
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath('image', file.path));
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  // Method DELETE
  Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final token = await _secureStorage.read(key: 'auth_token');

    return await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  // Method PATCH
  Future<http.Response> patch(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final token = await _secureStorage.read(key: 'auth_token');

    return await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
  }
}
