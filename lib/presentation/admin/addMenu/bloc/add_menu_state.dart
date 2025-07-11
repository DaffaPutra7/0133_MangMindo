part of 'add_menu_bloc.dart';

abstract class AddMenuState {}

final class AddMenuInitial extends AddMenuState {}
final class AddMenuLoading extends AddMenuState {}
final class AddMenuSuccess extends AddMenuState {}
final class AddMenuFailure extends AddMenuState {
  final String message;
  AddMenuFailure({required this.message});
}