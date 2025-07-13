import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:projek_akhir/data/model/response/user/order_riwayat_model.dart';
import 'package:projek_akhir/data/repository/order_repository.dart';

part 'riwayat_event.dart';
part 'riwayat_state.dart';

class RiwayatBloc extends Bloc<RiwayatEvent, RiwayatState> {
  final OrderRepository repository;

  RiwayatBloc(this.repository) : super(RiwayatInitial()) {
    on<FetchRiwayat>((event, emit) async {
      emit(RiwayatLoading());
      final result = await repository.getOrderRiwayat();
      result.fold(
        (error) => emit(RiwayatError(message: error)),
        (data) => emit(RiwayatLoaded(RiwayatResponse: data)),
      );
    });
  }
}
