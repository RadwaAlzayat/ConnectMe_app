import 'dart:async';

import 'package:firebase_core/firebase_core.dart';

import 'failures.dart';

/// One place that turns Firebase/Firestore errors into friendly messages,
/// shared by everything that talks to Firestore (posts, profiles...).
Failure mapFirestoreError(Object error) {
  if (error is TimeoutException) {
    return const NetworkFailure(
      'Could not reach the server. Check your connection.',
    );
  }
  if (error is FirebaseException) {
    switch (error.code) {
      case 'unavailable':
        return const NetworkFailure(
          'No internet connection. Please check your network.',
        );
      case 'permission-denied':
        return const Failure('You do not have permission to do that.');
    }
  }
  return const UnknownFailure();
}
