import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fpdart/fpdart.dart';
import 'package:order_track/core/errors/failure.dart';
import 'package:order_track/features/auth/domain/entities/user.dart';

class FirebaseAuthRemoteDataSource {
  final _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Either<LogInWithEmailAndPasswordFailure, User>> login(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      return Right(
        User(
          id: userCredential.user!.uid,
          email: userCredential.user!.email!,
          role: userDoc['role'],
        ),
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(LogInWithEmailAndPasswordFailure.fromCode(e.code));
    } catch (_) {
      return Left(LogInWithEmailAndPasswordFailure());
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Future<Either<LogInWithEmailAndPasswordFailure, User>>
      getCurrentUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        return Right(
          User(
            id: currentUser.uid,
            email: currentUser.email!,
            role: "",
          ),
        );
      }
      return Left(LogInWithEmailAndPasswordFailure());
    } catch (e) {
      return Left(LogInWithEmailAndPasswordFailure.fromCode(e.toString()));
    }
  }
}
