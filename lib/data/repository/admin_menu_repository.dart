import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:projek_akhir/data/model/request/admin/admin_menu_request_model.dart';
import 'package:projek_akhir/data/model/response/admin/admin_menu_response_model.dart';
import 'package:projek_akhir/service/service_http_client.dart';

class AdminMenuRepository {
  final ServiceHttpClient _httpClient;

  AdminMenuRepository(this._httpClient);

  Future<Either<String, MenuResponseModel>> getMenus() async {
    try {
      // Panggil http client langsung, token sudah diurus di dalamnya
      final response = await _httpClient.get('admin/menus');

      if (response.statusCode == 200) {
        return Right(MenuResponseModel.fromJson(response.body));
      } else {
        final error =
            jsonDecode(response.body)['message'] ?? 'Gagal mengambil data';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, String>> addMenu(AddMenuRequestModel model) async {
    try {
      // Gunakan method .post() biasa, bukan .postWithFile()
      final response = await _httpClient.post('admin/menus', model.toMap());

      if (response.statusCode == 201) {
        return const Right('Menu berhasil ditambahkan');
      } else {
        final error =
            jsonDecode(response.body)['message'] ?? 'Gagal menambah data';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, String>> updateMenu(
    int menuId,
    AddMenuRequestModel model,
  ) async {
    try {
      // Gunakan juga method .post() untuk update
      final response = await _httpClient.post(
        'admin/menus/update/$menuId',
        model.toMap(),
      );

      if (response.statusCode == 200) {
        return const Right('Menu berhasil diperbarui');
      } else {
        final error =
            jsonDecode(response.body)['message'] ?? 'Gagal memperbarui data';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, String>> deleteMenu(int menuId) async {
    try {
      final response = await _httpClient.delete('admin/menus/$menuId');

      if (response.statusCode == 200) {
        return const Right('Menu berhasil dihapus');
      } else {
        final error =
            jsonDecode(response.body)['message'] ?? 'Gagal menghapus data';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
