import 'dart:async';

import 'package:firebase_core/firebase_core.dart';

import '../../core/errors/failures.dart';
import '../../services/firestore_service.dart';
import '../models/post_model.dart';
import 'local_post_datasource.dart';
import 'post_datasource.dart';

/// Remote data source: reads and writes posts in Cloud Firestore.
class FirestorePostDataSource implements PostDataSource {
  FirestorePostDataSource(this._firestoreService, this._cache);

  final FirestoreService _firestoreService;
  final LocalPostDataSource _cache;

  static const String _collectionPath = 'posts';

  @override
  Stream<List<PostModel>> watchPosts() {
    return _firestoreService
        .collection(_collectionPath)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final posts = snapshot.docs
              .map((doc) => PostModel.fromJson(doc.data()))
              .toList();
          await _cache.savePosts(posts); // keep the offline copy fresh
          return posts;
        })
        .handleError((Object error) => throw _toFailure(error));
  }

  @override
  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    try {
      // doc() with no argument creates a reference with a new unique id.
      final documentReference = _firestoreService
          .collection(_collectionPath)
          .doc();
      final post = PostModel(
        id: documentReference.id,
        authorId: authorId,
        authorName: authorName,
        content: content,
        createdAt: DateTime.now(),
      );
      // Offline, Firestore keeps the write waiting forever; the timeout turns
      // that into a clear error instead of a spinner that never stops.
      await documentReference
          .set(post.toJson())
          .timeout(const Duration(seconds: 10));
    } catch (error) {
      throw _toFailure(error);
    }
  }

  /// One place that turns Firebase errors into friendly messages.
  Failure _toFailure(Object error) {
    if (error is TimeoutException) {
      return const NetworkFailure(
        'Could not reach the server. Check your connection.',
      );
    }
    if (error is FirebaseException) {
      switch (error.code) {
        case 'unavailable':
          return const NetworkFailure(
            'No internet connection. Please check your network.',
          );
        case 'permission-denied':
          return const Failure('You do not have permission to do that.');
      }
    }
    return const UnknownFailure();
  }
}
