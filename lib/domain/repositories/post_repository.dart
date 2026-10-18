import '../entities/post.dart';

/// The contract the domain layer depends on. The data layer implements it,
/// so use cases never know whether posts come from Firestore or a cache
/// (Dependency Inversion: high-level code depends on an abstraction).
abstract class PostRepository {
  /// Live list of posts, newest first.
  Stream<List<Post>> watchPosts();

  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  });
}
