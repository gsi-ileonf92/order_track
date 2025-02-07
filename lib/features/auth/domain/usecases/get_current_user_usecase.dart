import 'package:fpdart/fpdart.dart';
import 'package:order_track/core/errors/failure.dart';
import 'package:order_track/features/auth/domain/entities/user.dart';

import '../repositories/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  Future<Either<LogInWithEmailAndPasswordFailure, User>> call() async {
    return await repository.getCurrentUser();
  }
}
