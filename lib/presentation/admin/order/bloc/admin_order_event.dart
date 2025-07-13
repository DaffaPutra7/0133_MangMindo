part of 'admin_order_bloc.dart';

@immutable
sealed class AdminOrderEvent {}

class FetchAllOrders extends AdminOrderEvent {}

class UpdateStatusOrder extends AdminOrderEvent {
  final int orderId;
  final String newStatus;
  UpdateStatusOrder({required this.orderId, required this.newStatus});
}