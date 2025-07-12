part of 'edit_menu_bloc.dart';

abstract class EditMenuEvent {}

class UpdateMenuButtonPressed extends EditMenuEvent {
  final int menuId;
  final AddMenuRequestModel data; // Kita pakai ulang request model yang sama

  UpdateMenuButtonPressed({required this.menuId, required this.data});
}