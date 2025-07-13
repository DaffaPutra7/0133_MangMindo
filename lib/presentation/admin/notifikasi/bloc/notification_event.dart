part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

// Event untuk mulai memeriksa pesanan
class StartOrderCheck extends NotificationEvent {}

// Event internal saat timer berjalan
class _CheckOrders extends NotificationEvent {}

// Event untuk berhenti memeriksa pesanan
class StopOrderCheck extends NotificationEvent {}