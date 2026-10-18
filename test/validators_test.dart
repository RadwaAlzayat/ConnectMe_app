import 'package:connectme_app/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.fullName', () {
    test('rejects empty and lowercase-first names', () {
      expect(Validators.fullName(''), isNotNull);
      expect(Validators.fullName('radwa'), isNotNull);
    });

    test('accepts a capitalized name', () {
      expect(Validators.fullName('Radwa'), isNull);
    });
  });

  group('Validators.email', () {
    test('requires an @', () {
      expect(Validators.email('radwa.example.com'), isNotNull);
      expect(Validators.email('radwa@example.com'), isNull);
    });
  });

  group('Validators.password', () {
    test('requires at least 6 characters', () {
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password('123456'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('must match the original password', () {
      expect(Validators.confirmPassword('abc123', 'abc124'), isNotNull);
      expect(Validators.confirmPassword('abc123', 'abc123'), isNull);
    });
  });

  group('Validators.postContent', () {
    test('rejects empty or whitespace-only posts', () {
      expect(Validators.postContent(''), isNotNull);
      expect(Validators.postContent('   '), isNotNull);
    });

    test('rejects posts longer than the limit', () {
      final tooLong = 'a' * (Validators.maxPostLength + 1);
      expect(Validators.postContent(tooLong), isNotNull);
    });

    test('accepts a normal post', () {
      expect(Validators.postContent('Hello community'), isNull);
    });
  });
}
