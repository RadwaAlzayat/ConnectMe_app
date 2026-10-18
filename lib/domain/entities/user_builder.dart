import 'user.dart';

/// BUILDER PATTERN: builds an [AppUser] step by step, so only the fields we
/// actually have are set. At sign-up that is the uid, name and email; the
/// photo is added later, when the user picks one.
///
/// Why not a plain constructor? With a long list of optional fields, calls
/// like AppUser('1', '', 'a@b.com', null) are easy to get wrong; named setter
/// calls read like a sentence, and build() checks the required ones.

class UserBuilder {
  String? _uid;
  String? _fullName;
  String? _email;
  String? _photoBase64;

  // Each setter returns `this`, which is what allows the chained calls.
  UserBuilder setUid(String uid) {
    _uid = uid;
    return this;
  }

  UserBuilder setFullName(String fullName) {
    _fullName = fullName;
    return this;
  }

  UserBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  UserBuilder setPhotoBase64(String? photoBase64) {
    _photoBase64 = photoBase64;
    return this;
  }

  AppUser build() {
    final uid = _uid;
    final email = _email;
    if (uid == null || email == null) {
      throw StateError('UserBuilder needs at least a uid and an email.');
    }
    return AppUser(
      uid: uid,
      fullName: _fullName ?? '', // optional: accounts may have no name
      email: email,
      photoBase64: _photoBase64, // stays null when not provided
    );
  }
}
