part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartLoaded extends CartState {
  final List<OrderItem> items;
  final double totalPrice;

  CartLoaded({required this.items, required this.totalPrice});
}