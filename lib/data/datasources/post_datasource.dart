import '../models/post_model.dart';

/// Common interface for every place posts can come from (Firestore, local
/// cache...). Because they all look the same, the factory can hand back any
/// of them and the repository never needs to change.
abstract class PostDataSource {
  Stream<List<PostModel>> watchPosts();

  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  });
}
