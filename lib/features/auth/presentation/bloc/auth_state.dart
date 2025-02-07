part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class LoginFailure extends AuthState {
  final LogInWithEmailAndPasswordFailure failure;

  const LoginFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
