import 'package:projek_akhir/data/model/response/admin/admin_menu_response_model.dart';

// Model untuk item di dalam keranjang
class OrderItem {
  final Menu menu;
  int quantity;

  OrderItem({
    required this.menu,
    required this.quantity,
  });
}