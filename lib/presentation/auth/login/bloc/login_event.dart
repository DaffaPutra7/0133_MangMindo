part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final LoginRequestModel data;

  LoginButtonPressed({required this.data});
}

class LogoutButtonPressed extends LoginEvent {}