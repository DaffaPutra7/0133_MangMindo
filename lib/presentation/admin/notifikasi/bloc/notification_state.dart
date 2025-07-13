part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

// State saat ada pesanan baru masuk
final class NewOrderReceived extends NotificationState {
  final int newOrderCount;
  NewOrderReceived({required this.newOrderCount});
}