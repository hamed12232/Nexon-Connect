part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
class AuthUserLoaded extends AuthState {
  final UserModel user;
  AuthUserLoaded(this.user);
}
final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);
}
