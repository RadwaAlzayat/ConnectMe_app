/// Domain entity: pure Dart, no Firebase imports.
/// Create it with [UserBuilder] (user_builder.dart) so only the fields you
/// actually have get set.
class AppUser {
  const AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    this.photoBase64,
  });

  final String uid;
  final String fullName;
  final String email;

  /// Profile photo as base64 text. Null until the user picks one.
  final String? photoBase64;

  /// The name shown in the UI. Accounts created without a name fall back to
  /// the email, so screens never need to repeat this check.
  String get displayName => fullName.isNotEmpty ? fullName : email;
}
