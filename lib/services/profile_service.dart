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
