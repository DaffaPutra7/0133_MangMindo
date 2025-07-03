part of 'login_bloc.dart';

abstract class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final AuthResponseModel authResponse;
  LoginSuccess({required this.authResponse});
}

final class LoginFailure extends LoginState {
  final String message;
  LoginFailure({required this.message});
}