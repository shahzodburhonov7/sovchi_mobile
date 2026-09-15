part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
class LogInState extends AuthState {}
class RegistrationState extends AuthState {}
class ForgetPasswordState extends AuthState {}
class AuthErrorState extends AuthState {}
