part of 'add_menu_bloc.dart';

abstract class AddMenuEvent {}

class AddNewMenu extends AddMenuEvent {
  final AddMenuRequestModel model;
  AddNewMenu({required this.model});
}