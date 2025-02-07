import 'package:fpdart/fpdart.dart';
import 'package:order_track/core/errors/failure.dart';
import 'package:order_track/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<LogInWithEmailAndPasswordFailure, User>> login(
      String email, String password);
  Future<void> logout();
  Future<Either<LogInWithEmailAndPasswordFailure, User>> getCurrentUser();
}
