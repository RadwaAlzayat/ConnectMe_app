import '../core/errors/firestore_error_mapper.dart';
import '../data/models/user_model.dart';
import '../domain/entities/user.dart';
import 'firestore_service.dart';

/// Reads and writes the member profile (`users/{uid}`) in Firestore.
/// The profile document only exists once the user has picked a photo.
class ProfileService {
  ProfileService(this._firestoreService);

  final FirestoreService _firestoreService;

  static const String _collectionPath = 'users';

  /// Live profile; emits null while the user has no profile document yet.
  Stream<AppUser?> watchProfile(String uid) {
    return _firestoreService
        .collection(_collectionPath)
        .doc(uid)
        .snapshots()
        .map<AppUser?>((snapshot) {
          final data = snapshot.data();
          return data == null ? null : UserModel.fromJson(data);
        })
        .handleError((Object error) => throw mapFirestoreError(error));
  }

  /// One-time read of a member's photo (used to show it on their posts).
  /// Returns null when there is no photo or it cannot be read: a missing photo
  /// only means the first letter of the name is shown instead.
  Future<String?> fetchPhoto(String uid) async {
    try {
      final snapshot = await _firestoreService
          .collection(_collectionPath)
          .doc(uid)
          .get();
      final data = snapshot.data();
      return data == null ? null : UserModel.fromJson(data).photoBase64;
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProfile(AppUser user) async {
    try {
      await _firestoreService
          .collection(_collectionPath)
          .doc(user.uid)
          .set(UserModel.fromEntity(user).toJson())
          .timeout(const Duration(seconds: 10));
    } catch (error) {
      throw mapFirestoreError(error);
    }
  }
}
