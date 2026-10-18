import '../repositories/post_repository.dart';

/// Use case: "publish a new post".
class CreatePost {
  CreatePost(this._repository);

  final PostRepository _repository;

  Future<void> call({
    required String authorId,
    required String authorName,
    required String content,
  }) {
    return _repository.createPost(
      authorId: authorId,
      authorName: authorName,
      content: content.trim(),
    );
  }
}
