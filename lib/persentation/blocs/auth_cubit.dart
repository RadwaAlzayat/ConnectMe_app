import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../services/auth_service.dart';
import 'auth_state.dart';

/// Owns the authentication state of the whole app.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authService) : super(const AuthInitial());

  final AuthService _authService;

  /// Called once on app start: skips the login screen if a session exists.
  void checkAuthStatus() {
    final user = _authService.currentUser;
    emit(user == null ? const Unauthenticated() : Authenticated(user));
  }

  Future<void> signIn({required String email, required String password}) {
    return _runAuthAction(
      () => _authService.signIn(email: email, password: password),
    );
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _runAuthAction(
      () => _authService.signUp(
        fullName: fullName,
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signOut() {
    return _runAuthAction(() async {
      await _authService.signOut();
      return null; // no user left after signing out
    });
  }

  /// Shared flow for every auth action: loading -> result or error message.
  /// Keeping it here avoids repeating try/catch in each method.
  Future<void> _runAuthAction(Future<AppUser?> Function() action) async {
    emit(const AuthLoading());
    try {
      final user = await action();
      emit(user == null ? const Unauthenticated() : Authenticated(user));
    } on Failure catch (failure) {
      emit(AuthError(failure.message));
    }
  }
}
