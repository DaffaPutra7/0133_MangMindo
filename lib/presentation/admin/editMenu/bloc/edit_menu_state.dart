part of 'edit_menu_bloc.dart';

abstract class EditMenuState {}

final class EditMenuInitial extends EditMenuState {}
final class EditMenuLoading extends EditMenuState {}
final class EditMenuSuccess extends EditMenuState {}
final class EditMenuFailure extends EditMenuState {
  final String message;
  EditMenuFailure({required this.message});
}