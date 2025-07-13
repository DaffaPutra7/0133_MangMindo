import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:projek_akhir/data/model/response/admin/admin_menu_response_model.dart';
import 'package:projek_akhir/data/repository/customer_menu_repository.dart';

part 'customer_menu_event.dart';
part 'customer_menu_state.dart';

class CustomerMenuBloc extends Bloc<CustomerMenuEvent, CustomerMenuState> {
  final CustomerMenuRepository repository;
  
  CustomerMenuBloc(this.repository) : super(CustomerMenuInitial()) {
    // handler untuk event FetchCustomerMenus
    on<FetchCustomerMenus>((event, emit) async {
      emit(CustomerMenuLoading());
      final result = await repository.getMenus();
      result.fold(
        (error) => emit(CustomerMenuError(message: error)),
        (data) => emit(CustomerMenuLoaded(menuResponse: data)),
      );
    });
  }
}
