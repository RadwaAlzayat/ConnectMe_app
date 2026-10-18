import 'dart:async';

import 'package:connectme_app/core/errors/failures.dart';
import 'package:connectme_app/domain/entities/post.dart';
import 'package:connectme_app/domain/usecases/create_posts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_posts.dart';
import 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit(this._getPosts, this._creatPost) : super(const PostInitial());

  final GetPosts _getPosts;
  final CreatePost _creatPost;

  StreamSubscription<List<Post>>? _postsSubscription;

  void watchPosts() {
    emit(PostLoading());
    _postsSubscription?.cancel();
    _postsSubscription = _getPosts().listen(
      (posts) => emit(PostLoaded(posts)),
      onError: (Object error) => emit(
        PostError(
          error is Failure ? error.message : const UnknownFailure().message,
        ),
      ),
    );
  }

  Future<void> createPost({
    required AppUser author,
    required String content,
  }) async {
    return _creatPost(
      authorId: author.uid,
      authorName: author.displayName,
      content: content,
    );
  }

  @override
  Future<void> close() {
    _postsSubscription?.cancel();
    return super.close();
  }
}
