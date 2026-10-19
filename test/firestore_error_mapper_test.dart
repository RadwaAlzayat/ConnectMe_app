import 'dart:async';

import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/core/errors/firestore_error_mapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapFirestoreError', () {
    test('turns a timeout into a network failure', () {
      expect(
        mapFirestoreError(TimeoutException('slow')),
        isA<NetworkFailure>(),
      );
    });

    test('maps known Firestore codes to friendly messages', () {
      final unavailable = FirebaseException(
        plugin: 'firestore',
        code: 'unavailable',
      );
      final denied = FirebaseException(
        plugin: 'firestore',
        code: 'permission-denied',
      );

      expect(mapFirestoreError(unavailable), isA<NetworkFailure>());
      expect(mapFirestoreError(denied).message, contains('permission'));
    });

    test('hides anything unknown behind a generic failure', () {
      expect(mapFirestoreError(StateError('boom')), isA<UnknownFailure>());
    });
  });
}
