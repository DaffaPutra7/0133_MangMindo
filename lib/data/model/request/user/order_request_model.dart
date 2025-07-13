import 'dart:convert';
import 'package:projek_akhir/data/model/request/user/order_item_model.dart';

class OrderRequestModel {
  final List<OrderItem> items;

  OrderRequestModel({required this.items});

  Map<String, dynamic> toMap() {
    return {
      // Sesuai dengan yang diharapkan backend: 'items' adalah sebuah array
      'items': items.map((item) => {
        'menu_id': item.menu.id,
        'quantity': item.quantity,
      }).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}