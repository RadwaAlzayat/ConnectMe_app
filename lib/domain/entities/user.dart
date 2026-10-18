/// Domain entity: pure Dart, no Firebase imports.
/// (In a later step this gets a Builder so only sign-up fields are set.)
class AppUser {
  const AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
  });

  final String uid;
  final String fullName;
  final String email;

  String get displayName => fullName.isNotEmpty ? fullName : email;
}
