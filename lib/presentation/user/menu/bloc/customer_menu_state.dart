part of 'customer_menu_bloc.dart';

@immutable
sealed class CustomerMenuState {}

final class CustomerMenuInitial extends CustomerMenuState {}

// State untuk kondisi memuat data
final class CustomerMenuLoading extends CustomerMenuState {}

// State untuk kondisi data berhasil dimuat
final class CustomerMenuLoaded extends CustomerMenuState {
  final MenuResponseModel menuResponse;
  CustomerMenuLoaded({required this.menuResponse});
}

// State untuk kondisi gagal memuat data
final class CustomerMenuError extends CustomerMenuState {
  final String message;
  CustomerMenuError({required this.message});
}