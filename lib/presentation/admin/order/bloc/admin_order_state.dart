part of 'admin_order_bloc.dart';

@immutable
sealed class AdminOrderState {}

final class AdminOrderInitial extends AdminOrderState {}
final class AdminOrderLoading extends AdminOrderState {}
final class AdminOrderLoaded extends AdminOrderState {
  final OrderRiwayatResponseModel orderResponse;
  AdminOrderLoaded({required this.orderResponse});
}
final class AdminOrderError extends AdminOrderState {
  final String message;
  AdminOrderError({required this.message});
}
// State untuk notifikasi
final class AdminOrderUpdateSuccess extends AdminOrderState {}
final class AdminOrderUpdateFailure extends AdminOrderState {
    final String message;
    AdminOrderUpdateFailure({required this.message});
}