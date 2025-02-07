import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:order_track/core/errors/failure.dart';
import 'package:order_track/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:order_track/features/auth/domain/entities/user.dart';
import 'package:order_track/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthRemoteDataSource remoteDataSource;
  final FirebaseFirestore firestore;

  AuthRepositoryImpl({required this.remoteDataSource, required this.firestore});

  @override
  Future<Either<LogInWithEmailAndPasswordFailure, User>> login(
      String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<Either<LogInWithEmailAndPasswordFailure, User>>
      getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }
}
