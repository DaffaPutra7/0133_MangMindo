import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/data/model/response/admin/admin_menu_response_model.dart';
import 'package:projek_akhir/data/repository/admin_menu_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenusBloc extends Bloc<MenuEvent, MenuState> {
  final AdminMenuRepository repository;

  MenusBloc(this.repository) : super(MenuInitial()) {
    on<GetMenu>((event, emit) async {
      emit(MenuLoading());
      final result = await repository.getMenus();
      result.fold(
        (error) => emit(MenuError(message: error)),
        (data) => emit(MenuLoaded(menuResponse: data)),
      );
    });

    // ✅ Tambahkan handler untuk event DeleteMenu
    on<DeleteMenu>((event, emit) async {
      final result = await repository.deleteMenu(event.menuId);
      result.fold(
        (error) => emit(MenuActionFailure(message: error)),
        (message) => emit(MenuActionSuccess(message: message)),
      );
    });
  }
}