import 'package:local_auth/local_auth.dart';

import '../core/errors/failures.dart';

/// The only class that talks to local_auth (fingerprint prompt).
class BiometricService {
  BiometricService(this._localAuth);

  final LocalAuthentication _localAuth;

  /// Shows the fingerprint prompt. Returns true only when the user passes it.
  /// Problems (no sensor, nothing enrolled, locked out) become a [Failure]
  /// with a friendly message.
  Future<bool> authenticate() async {
    try {
      final enrolledBiometrics = await _localAuth.getAvailableBiometrics();
      if (enrolledBiometrics.isEmpty) {
        throw const Failure(
          'No fingerprint is set up on this phone. '
          'Add one in Settings, then try again.',
        );
      }

      return await _localAuth.authenticate(
        localizedReason: 'Verify your fingerprint to open your profile',
        biometricOnly: true, // no PIN/pattern fallback: fingerprint required
      );
    } on Failure {
      rethrow;
    } on LocalAuthException catch (error) {
      throw _toFailure(error);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Failure _toFailure(LocalAuthException error) {
    final code = error.code;

    if (code == LocalAuthExceptionCode.noBiometricHardware) {
      return const Failure('This phone has no fingerprint sensor.');
    }
    if (code == LocalAuthExceptionCode.temporaryLockout ||
        code == LocalAuthExceptionCode.biometricLockout) {
      return const Failure(
        'Too many attempts. Try again later or unlock your phone with its PIN.',
      );
    }
    // Includes the user closing the prompt.
    return const Failure(
      'Fingerprint check was not completed. Please try again.',
    );
  }
}
