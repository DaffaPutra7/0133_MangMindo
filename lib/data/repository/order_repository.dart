import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:projek_akhir/data/model/request/user/order_request_model.dart';
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
        final error = jsonDecode(response.body)['message'] ?? 'Gagal membuat pesanan';
        return Left(error);
      }
    } catch (e) {
      return Left('Terjadi kesalahan: ${e.toString()}');
    }
  }
}