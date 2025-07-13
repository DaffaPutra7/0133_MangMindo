part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class DoOrder extends OrderEvent {
  final OrderRequestModel model;
  DoOrder({required this.model});
}