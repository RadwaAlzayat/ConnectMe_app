import '../../core/errors/failures.dart';
import '../../data/datasources/post_datasource_factory.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';

/// Implements the domain contract. It never builds a data source itself: it
/// asks the factory, so it depends only on abstractions (see the Factory
/// pattern in post_datasource_factory.dart).
class PostRepositoryImpl implements PostRepository {
  PostRepositoryImpl(this._dataSourceFactory);

  final PostDataSourceFactory _dataSourceFactory;

  @override
  Stream<List<Post>> watchPosts() async* {
    try {
      // `await for` (not `yield*`) so errors from the stream can be caught.
      await for (final posts
          in _dataSourceFactory.create(PostSource.remote).watchPosts()) {
        yield posts;
      }
    } on Failure {
      // The server is unreachable: show the posts saved on the phone instead.
      final cachedPosts = await _dataSourceFactory
          .create(PostSource.local)
          .watchPosts()
          .first;
      // Nothing saved either: let the user see the real error message.
      if (cachedPosts.isEmpty) rethrow;
      yield cachedPosts;
    }
  }

  @override
  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) {
    return _dataSourceFactory
        .create(PostSource.remote)
        .createPost(
          authorId: authorId,
          authorName: authorName,
          content: content,
        );
  }
}
