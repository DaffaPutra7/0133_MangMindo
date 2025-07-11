import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/data/model/request/admin/admin_menu_request_model.dart';
import 'package:projek_akhir/data/repository/admin_menu_repository.dart';

part 'add_menu_event.dart';
part 'add_menu_state.dart';

class AddMenuBloc extends Bloc<AddMenuEvent, AddMenuState> {
  final AdminMenuRepository repository;

  AddMenuBloc(this.repository) : super(AddMenuInitial()) {
    on<AddNewMenu>((event, emit) async {
      emit(AddMenuLoading());
      final result = await repository.addMenu(event.model);
      result.fold(
        (error) => emit(AddMenuFailure(message: error)),
        (data) => emit(AddMenuSuccess()),
      );
    });
  }
}