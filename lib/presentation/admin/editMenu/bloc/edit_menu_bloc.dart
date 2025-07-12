import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/data/model/request/admin/admin_menu_request_model.dart';
import 'package:projek_akhir/data/repository/admin_menu_repository.dart';

part 'edit_menu_event.dart';
part 'edit_menu_state.dart';

class EditMenuBloc extends Bloc<EditMenuEvent, EditMenuState> {
  final AdminMenuRepository repository;

  EditMenuBloc(this.repository) : super(EditMenuInitial()) {
    on<UpdateMenuButtonPressed>((event, emit) async {
      emit(EditMenuLoading());
      final result = await repository.updateMenu(event.menuId, event.data);
      result.fold(
        (error) => emit(EditMenuFailure(message: error)),
        (data) => emit(EditMenuSuccess()),
      );
    });
  }
}