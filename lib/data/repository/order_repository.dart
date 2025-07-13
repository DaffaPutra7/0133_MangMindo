import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:projek_akhir/data/model/request/user/order_request_model.dart';
import 'package:projek_akhir/data/model/request/user/review_request_model.dart';
import 'package:projek_akhir/data/model/response/user/order_riwayat_model.dart';
import 'package:projek_akhir/service/service_http_client.dart';

class OrderRepository {
  final ServiceHttpClient _httpClient;
  OrderRepository(this._httpClient);

  Future<Either<String, bool>> createOrder(OrderRequestModel model) async {
    try {
      final response = await _httpClient.post('orders', model.toMap());

      if (response.statusCode == 201) {
        return const Right(true);
      } else {
        final error =
            jsonDecode(response.body)['message'] ?? 'Gagal membuat pesanan';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, OrderRiwayatResponseModel>> getOrderRiwayat() async {
    try {
      // Panggil endpoint GET /orders
      final response = await _httpClient.get('orders');

      if (response.statusCode == 200) {
        return Right(OrderRiwayatResponseModel.fromJson(response.body));
      } else {
        final error =
            jsonDecode(response.body)['message'] ?? 'Gagal mengambil data';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<Either<String, ReviewModel>> addReview(
    int orderId,
    ReviewRequestModel model,
  ) async {
    try {
      final response = await _httpClient.post(
        'orders/$orderId/review',
        model.toMap(),
      );

      if (response.statusCode == 201) {
        return Right(ReviewModel.fromMap(jsonDecode(response.body)));
      } else {
        final error =
            jsonDecode(response.body)['message'] ?? 'Gagal mengirim review';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }
}
