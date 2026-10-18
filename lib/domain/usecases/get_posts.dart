import '../entities/post.dart';
import '../repositories/post_repository.dart';

/// Use case: "give me the live list of posts". One class = one action, so the
/// Cubit asks for exactly what it needs and nothing else.
class GetPosts {
  GetPosts(this._repository);

  final PostRepository _repository;

  Stream<List<Post>> call() => _repository.watchPosts();
}
