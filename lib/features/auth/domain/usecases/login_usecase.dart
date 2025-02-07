import 'package:fpdart/fpdart.dart';
import 'package:order_track/core/errors/failure.dart';
import 'package:order_track/features/auth/domain/entities/user.dart';
import 'package:order_track/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<LogInWithEmailAndPasswordFailure, User>> call(
      String email, String password) async {
    return repository.login(email, password);
  }
}
