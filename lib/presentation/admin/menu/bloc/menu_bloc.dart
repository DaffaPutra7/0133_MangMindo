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
  }
}