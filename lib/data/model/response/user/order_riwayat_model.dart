import 'dart:convert';
import 'package:projek_akhir/data/model/response/admin/admin_menu_response_model.dart';

class OrderRiwayatResponseModel {
  final List<OrderModel> data;

  OrderRiwayatResponseModel({required this.data});

  factory OrderRiwayatResponseModel.fromJson(String str) =>
      OrderRiwayatResponseModel.fromMap(json.decode(str));

  factory OrderRiwayatResponseModel.fromMap(List<dynamic> json) =>
      OrderRiwayatResponseModel(
        data: List<OrderModel>.from(json.map((x) => OrderModel.fromMap(x))),
      );
}

class ReviewModel {
  final int rating;
  final String? comment;

  ReviewModel({required this.rating, this.comment});

  factory ReviewModel.fromMap(Map<String, dynamic> json) => ReviewModel(
        rating: json["rating"],
        comment: json["comment"],
      );
}

class OrderModel {
  final int id;
  final int userId;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final List<OrderItemModel> items; 
  final ReviewModel? review;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.items,
    this.review,
  });

  factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
        id: json["id"],
        userId: json["user_id"],
        totalPrice: double.tryParse(json["total_price"].toString()) ?? 0.0,
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        items: List<OrderItemModel>.from(
            json["items"].map((x) => OrderItemModel.fromMap(x))),
        review: json["review"] == null ? null : ReviewModel.fromMap(json["review"]),
      );
}

class OrderItemModel {
  final int id;
  final int quantity;
  final double price;
  final Menu menu; 

  OrderItemModel({
    required this.id,
    required this.quantity,
    required this.price,
    required this.menu,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> json) => OrderItemModel(
        id: json["id"],
        quantity: json["quantity"],
        price: double.tryParse(json["price"].toString()) ?? 0.0,
        menu: Menu.fromMap(json["menu"]),
      );
}