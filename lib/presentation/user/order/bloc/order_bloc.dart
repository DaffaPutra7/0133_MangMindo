import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:projek_akhir/data/model/request/user/order_request_model.dart';
import 'package:projek_akhir/data/repository/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository repository;
  OrderBloc(this.repository) : super(OrderInitial()) {
    on<DoOrder>((event, emit) async {
      emit(OrderLoading());
      final result = await repository.createOrder(event.model);
      result.fold(
        (l) => emit(OrderFailure(message: l)),
        (r) => emit(OrderSuccess()),
      );
    });
  }
}