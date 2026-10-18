import 'package:connectme_app/domain/entities/user_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserBuilder', () {
    test('sets only the fields that were provided', () {
      final user = UserBuilder()
          .setUid('u1')
          .setEmail('radwa@example.com')
          .setFullName('Radwa')
          .build();

      expect(user.uid, 'u1');
      expect(user.fullName, 'Radwa');
      expect(user.photoBase64, isNull); // not provided at sign-up
    });

    test('works without a name and falls back to the email for display', () {
      final user = UserBuilder().setUid('u2').setEmail('a@b.com').build();

      expect(user.fullName, '');
      expect(user.displayName, 'a@b.com');
    });

    test('throws when a required field is missing', () {
      expect(() => UserBuilder().setEmail('a@b.com').build(), throwsStateError);
      expect(() => UserBuilder().setUid('u3').build(), throwsStateError);
    });
  });
}
