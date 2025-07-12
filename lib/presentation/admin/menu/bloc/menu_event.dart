part of 'menu_bloc.dart';

abstract class MenuEvent {}

class GetMenu extends MenuEvent {}

// Event baru untuk memicu proses hapus
class DeleteMenu extends MenuEvent {
  final int menuId;
  DeleteMenu({required this.menuId});
}