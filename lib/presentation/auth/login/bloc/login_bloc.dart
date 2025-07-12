import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projek_akhir/data/model/request/auth/login_request_model.dart';
import 'package:projek_akhir/data/model/response/auth/auth_response_model.dart';
import 'package:projek_akhir/data/repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      // Memanggil method login yang general dari repository
      final result = await repository.login(event.data);
      result.fold(
        (failure) => emit(LoginFailure(message: failure)),
        (success) => emit(LoginSuccess(authResponse: success)),
      );
    });

    on<LogoutButtonPressed>((event, emit) async {
      await repository.logout();
      // Kembalikan state ke awal setelah logout
      emit(LoginInitial());
    });
  }
}