part of 'auth_cubit.dart';

@immutable
abstract class AuthState {
  final String errorMessage;

  AuthState(this.errorMessage);
}

class AuthInitial extends AuthState {
  AuthInitial(super.errorMessage);
}

class AuthSignInLoading extends AuthState {
  AuthSignInLoading(super.errorMessage);
}

class AuthSignInFailure extends AuthState {
  AuthSignInFailure(super.errorMessage);
}

class AuthSignInSuccess extends AuthState {
  AuthSignInSuccess(super.errorMessage);
}

class AuthSignOutSuccess extends AuthState {
  AuthSignOutSuccess(super.errorMessage);
}
