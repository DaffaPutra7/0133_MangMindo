import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:projek_akhir/data/model/request/auth/register_request_model.dart';
import 'package:projek_akhir/data/model/response/auth/auth_response_model.dart';
import 'package:projek_akhir/data/repository/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc(this._authRepository) : super(RegisterInitial()) {
    on<RegisterButtonPressed>((event, emit) async {
      emit(RegisterLoading());
      final result = await _authRepository.register(event.data);
      result.fold(
        (failure) => emit(RegisterFailure(message: failure)),
        (success) => emit(RegisterSuccess(authResponse: success)),
      );
    });
  }
}