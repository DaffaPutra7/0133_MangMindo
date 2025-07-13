import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:projek_akhir/data/model/response/user/order_riwayat_model.dart';
import 'package:projek_akhir/data/repository/admin_order_repository.dart';

part 'admin_order_event.dart';
part 'admin_order_state.dart';

class AdminOrderBloc extends Bloc<AdminOrderEvent, AdminOrderState> {
  final AdminOrderRepository repository;

  AdminOrderBloc(this.repository) : super(AdminOrderInitial()) {
    on<FetchAllOrders>((event, emit) async {
      emit(AdminOrderLoading());
      final result = await repository.getAllOrders();
      result.fold(
        (l) => emit(AdminOrderError(message: l)),
        (r) => emit(AdminOrderLoaded(orderResponse: r)),
      );
    });

    on<UpdateStatusOrder>((event, emit) async {
      final result = await repository.updateOrderStatus(event.orderId, event.newStatus);
       result.fold(
        (l) => emit(AdminOrderUpdateFailure(message: l)),
        (r) => emit(AdminOrderUpdateSuccess()),
      );
    });
  }
}