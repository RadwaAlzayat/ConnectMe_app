import '../../domain/entities/user.dart';

/// Data-layer version of [AppUser]: adds the JSON conversion used to store
/// the profile in Firestore (collection `users`, document id = uid).
class UserModel extends AppUser {
  const UserModel({
    required super.uid,
    required super.fullName,
    required super.email,
    super.photoBase64,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String,
      photoBase64: json['photoBase64'] as String?,
    );
  }

  factory UserModel.fromEntity(AppUser user) {
    return UserModel(
      uid: user.uid,
      fullName: user.fullName,
      email: user.email,
      photoBase64: user.photoBase64,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'photoBase64': photoBase64,
    };
  }
}
