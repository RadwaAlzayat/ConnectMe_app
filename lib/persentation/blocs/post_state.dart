import '../../domain/entities/post.dart';

/// Every state the feed can be in.
sealed class PostState {
  const PostState();
}

class PostInitial extends PostState {
  const PostInitial();
}

class PostLoading extends PostState {
  const PostLoading();
}

class PostLoaded extends PostState {
  const PostLoaded(this.posts);

  final List<Post> posts;
}

class PostError extends PostState {
  const PostError(this.message);
  final String message;
}
