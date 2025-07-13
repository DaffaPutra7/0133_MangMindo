part of 'riwayat_bloc.dart';

@immutable
sealed class RiwayatState {}

final class RiwayatInitial extends RiwayatState {}
final class RiwayatLoading extends RiwayatState {}
final class RiwayatLoaded extends RiwayatState {
  final OrderRiwayatResponseModel RiwayatResponse;
  RiwayatLoaded({required this.RiwayatResponse});
}
final class RiwayatError extends RiwayatState {
  final String message;
  RiwayatError({required this.message});
}