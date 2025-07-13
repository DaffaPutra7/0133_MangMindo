import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:projek_akhir/data/model/response/user/order_riwayat_model.dart';
import 'package:projek_akhir/service/service_http_client.dart';

class AdminOrderRepository {
  final ServiceHttpClient _httpClient;
  AdminOrderRepository(this._httpClient);

  // Mengambil SEMUA pesanan untuk admin
  Future<Either<String, OrderRiwayatResponseModel>> getAllOrders() async {
    try {
      final response = await _httpClient.get('admin/orders');
      if (response.statusCode == 200) {
        return Right(OrderRiwayatResponseModel.fromJson(response.body));
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Gagal mengambil data';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Mengubah status pesanan
  Future<Either<String, bool>> updateOrderStatus(int orderId, String status) async {
    try {
      final response = await _httpClient.patch(
        'admin/orders/$orderId',
        {'status': status},
      );
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Gagal mengubah status';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }
}