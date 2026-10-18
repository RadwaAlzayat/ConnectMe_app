/// Form validation rules in ONE place (no duplicated checks in the screens).
/// Each method returns an error message, or null when the value is valid.
class Validators {
  Validators._();
  static const int maxPostLength = 500;

  static String? fullName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Full name is required';
    if (!RegExp(r'^[A-Z]').hasMatch(name)) {
      return 'Full name must start with a capital letter';
    }
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email is required';
    if (!email.contains('@')) return 'Email must contain @';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != originalPassword) return 'Passwords do not match';
    return null;
  }

  static String? postContent(String? value) {
    final content = value?.trim() ?? "";
    if (content.isEmpty) return 'Write something before posting';
    if (content.length > maxPostLength) {
      return 'Post is too long (max $maxPostLength characters)';
    }
    return null;
  }
}
