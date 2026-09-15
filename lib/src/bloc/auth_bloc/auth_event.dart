part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LogInEvent extends AuthEvent {
  String login;
  String password;

  LogInEvent({required this.login, required this.password});
}

class RegistrationEvent extends AuthEvent {
  String numberOrEmail ;
  RegistrationEvent({required this.numberOrEmail});
}

class ForgetPasswordEvent extends AuthEvent {
  String login;
  ForgetPasswordEvent({required this.login});
}
