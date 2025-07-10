part of 'menu_bloc.dart';

abstract class MenuState {}

final class MenuInitial extends MenuState {}
final class MenuLoading extends MenuState {}
final class MenuLoaded extends MenuState {
  final MenuResponseModel menuResponse;
  MenuLoaded({required this.menuResponse});
}
final class MenuError extends MenuState {
  final String message;
  MenuError({required this.message});
}