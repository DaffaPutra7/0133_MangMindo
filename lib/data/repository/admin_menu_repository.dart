import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:projek_akhir/data/model/response/admin/admin_menu_response_model.dart';
import 'package:projek_akhir/service/service_http_client.dart';

class AdminMenuRepository {
  final ServiceHttpClient _httpClient;

  AdminMenuRepository(this._httpClient);

  Future<Either<String, MenuResponseModel>> getMenus() async {
    try {
      // Langsung panggil http client dari repository
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
}
