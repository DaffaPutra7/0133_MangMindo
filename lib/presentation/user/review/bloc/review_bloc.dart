import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:projek_akhir/data/model/request/user/review_request_model.dart';
import 'package:projek_akhir/data/repository/order_repository.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final OrderRepository repository;

  ReviewBloc(this.repository) : super(ReviewInitial()) {
    on<SubmitReview>((event, emit) async {
      emit(ReviewLoading());
      final result = await repository.addReview(event.orderId, event.data);
      result.fold(
        (l) => emit(ReviewFailure(message: l)),
        (r) => emit(ReviewSuccess()),
      );
    });
  }
}