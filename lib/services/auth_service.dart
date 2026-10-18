import 'package:firebase_auth/firebase_auth.dart';

import '../core/errors/failures.dart';
import '../domain/entities/user.dart';
import '../domain/entities/user_builder.dart';

/// The only class that talks to Firebase Auth. Screens and cubits never
/// import firebase_auth, so the data source can change without touching them.
class AuthService {
  AuthService(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  /// Firebase restores the saved session on app start, so a non-null value
  /// here means the user is already signed in (auth state persistence).
  AppUser? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser == null ? null : _toAppUser(firebaseUser);
  }

  Future<AppUser> signIn({required String email, required String password}) {
    return _guard(() async {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _toAppUser(credential.user!);
    });
  }

  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _guard(() async {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user!.updateDisplayName(fullName.trim());
      await credential.user!.reload();
      return _toAppUser(_firebaseAuth.currentUser!);
    });
  }

  Future<void> signOut() => _guard(_firebaseAuth.signOut);

  /// Runs an action and turns ANY exception into a [Failure], so nothing
  /// unhandled can reach the UI.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on FirebaseAuthException catch (error) {
      throw _mapAuthError(error);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Failure _mapAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return const AuthFailure('The email address is not valid.');
      case 'user-disabled':
        return const AuthFailure('This account has been disabled.');
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const AuthFailure('Incorrect email or password.');
      case 'email-already-in-use':
        return const AuthFailure('An account already exists for this email.');
      case 'weak-password':
        return const AuthFailure('The password is too weak.');
      case 'too-many-requests':
        return const AuthFailure('Too many attempts. Please try again later.');
      case 'network-request-failed':
        return const NetworkFailure(
          'No internet connection. Please check your network.',
        );
      default:
        return const AuthFailure('Authentication failed. Please try again.');
    }
  }

  /// Builder pattern in use: only the fields we have at sign-up are set.
  /// The photo is not provided here, so it stays null until the user picks one.
  AppUser _toAppUser(User firebaseUser) {
    return UserBuilder()
        .setUid(firebaseUser.uid)
        .setEmail(firebaseUser.email ?? '')
        .setFullName(firebaseUser.displayName ?? '')
        .build();
  }
}
