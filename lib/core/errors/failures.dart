/// Base type for every error the UI is allowed to show.
/// Services convert raw exceptions into a
/// Failure with a friendly message, so screens never see raw exceptions.
class Failure implements Exception {
  const Failure(this.message);

  final String message;
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'Something went wrong. Please try again.',
  ]);
}
