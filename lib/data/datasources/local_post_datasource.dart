import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/errors/failures.dart';
import '../models/post_model.dart';
import 'post_datasource.dart';

/// Local cache: keeps the latest posts on the phone so the feed can still
/// show something when Firestore cannot be reached.
class LocalPostDataSource implements PostDataSource {
  LocalPostDataSource(this._preferences);

  final SharedPreferences _preferences;

  static const String _cacheKey = 'cached_posts';
  static const int _maxCachedPosts = 50;

  @override
  Stream<List<PostModel>> watchPosts() async* {
    yield _readCachedPosts();
  }

  /// The cache is read-only for users: a new post must reach the server.
  @override
  Future<void> createPost({
    required String authorId,
    required String authorName,
    required String content,
  }) async {
    throw const NetworkFailure(
      'You are offline. Connect to the internet to publish a post.',
    );
  }

  /// Called by the remote data source every time fresh posts arrive.
  Future<void> savePosts(List<PostModel> posts) {
    final encodedPosts = jsonEncode(
      posts.take(_maxCachedPosts).map((post) => post.toJson()).toList(),
    );
    return _preferences.setString(_cacheKey, encodedPosts);
  }

  List<PostModel> _readCachedPosts() {
    final encodedPosts = _preferences.getString(_cacheKey);
    if (encodedPosts == null) return [];

    try {
      final decodedPosts = jsonDecode(encodedPosts) as List<dynamic>;
      return decodedPosts
          .map((item) => PostModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on FormatException {
      return []; // a damaged cache is treated as an empty cache
    }
  }
}
