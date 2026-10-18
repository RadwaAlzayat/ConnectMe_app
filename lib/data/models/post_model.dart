import '../../domain/entities/post.dart';

/// Data-layer version of [Post]: adds the JSON conversion needed to talk to
/// Firestore and to the local cache.
///
/// `createdAt` is stored as milliseconds since epoch (an int) so the SAME
/// toJson/fromJson works for Firestore and for local JSON storage.
class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.authorId,
    required super.authorName,
    required super.content,
    required super.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      content: json['content'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
