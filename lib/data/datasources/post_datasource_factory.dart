import 'package:shared_preferences/shared_preferences.dart';

import '../../services/firestore_service.dart';
import 'firestore_post_datasource.dart';
import 'local_post_datasource.dart';
import 'post_datasource.dart';

enum PostSource { remote, local }

/// FACTORY PATTERN: the only place that knows which concrete class to build.
/// The repository just asks for a [PostSource] and receives a [PostDataSource],
/// so it never depends on Firestore or SharedPreferences directly and a new
/// source can be added here without touching the repository.
class PostDataSourceFactory {
  PostDataSourceFactory(this._firestoreService, this._preferences);

  final FirestoreService _firestoreService;
  final SharedPreferences _preferences;

  PostDataSource create(PostSource source) {
    final cache = LocalPostDataSource(_preferences);

    switch (source) {
      case PostSource.remote:
        return FirestorePostDataSource(_firestoreService, cache);
      case PostSource.local:
        return cache;
    }
  }
}
