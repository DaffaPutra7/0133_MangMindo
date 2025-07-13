import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:projek_akhir/data/model/request/auth/register_request_model.dart';
import '../../service/service_http_client.dart';
import '../model/request/auth/login_request_model.dart';
import '../model/response/auth/auth_response_model.dart';

class AuthRepository {
  final ServiceHttpClient _httpClient;
  final _secureStorage = const FlutterSecureStorage();

  AuthRepository(this._httpClient);

  // Method login yang general untuk admin dan customer
  Future<Either<String, AuthResponseModel>> login(
    LoginRequestModel model,
  ) async {
    try {
      // Memanggil endpoint /api/login yang sudah kita satukan di backend
      final response = await _httpClient.post('login', model.toMap());

      if (response.statusCode == 200) {
        final authResponse = AuthResponseModel.fromJson(response.body);

        // Simpan token dengan satu nama kunci yang sama
        await _secureStorage.write(
          key: 'auth_token',
          value: authResponse.accessToken,
        );

        // Simpan juga role pengguna untuk navigasi nanti
        await _secureStorage.write(key: 'user_role', value: authResponse.role);

        return Right(authResponse);
      } else {
        // Mengambil pesan error dari backend
        final error = jsonDecode(response.body)['error'] ?? 'Login Gagal';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan. Periksa koneksi Anda.');
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      // Panggil endpoint logout, tidak perlu pedulikan responsnya selama berhasil
      await _httpClient.post('logout', {});
      // Hapus token dari local storage
      await _secureStorage.delete(key: 'auth_token');
      return const Right('Logout berhasil');
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, AuthResponseModel>> register(
    RegisterRequestModel model,
  ) async {
    try {
      final response = await _httpClient.post('register', model.toMap());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = AuthResponseModel.fromJson(response.body);

        // Simpan token dan role setelah registrasi berhasil
        await _secureStorage.write(
          key: 'auth_token',
          value: authResponse.accessToken,
        );
        await _secureStorage.write(key: 'user_role', value: authResponse.role);

        return Right(authResponse);
      } else {
        // Mengambil pesan error dari backend
        final errors = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessages = errors.entries.map((e) => e.value[0]).join('\n');
        return Left(errorMessages);
      }
    } catch (e) {
      return Left('Terjadi kesalahan. Periksa koneksi Anda.');
    }
  }
}
