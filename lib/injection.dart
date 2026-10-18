import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/post_datasource_factory.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/repositories/post_repository_impl.dart';
import 'domain/usecases/create_posts.dart';
import 'domain/usecases/get_posts.dart';
import 'persentation/blocs/auth_cubit.dart';
import 'services/auth_service.dart';
import 'services/firestore_service.dart';

final getIt = GetIt.instance;

/// The single place where dependencies are wired together.
/// Async because SharedPreferences must finish loading before the app starts.
Future<void> setupInjection() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  // Services
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(FirebaseAuth.instance),
  );
  // FirestoreService is already a Singleton by itself; GetIt just hands it out.
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());

  // Data layer
  getIt.registerLazySingleton<PostDataSourceFactory>(
    () => PostDataSourceFactory(getIt<FirestoreService>(), sharedPreferences),
  );

  // Repositories are registered under the domain contract, so the rest of the
  // app asks for PostRepository and never sees PostRepositoryImpl.
  getIt.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(getIt<PostDataSourceFactory>()),
  );

  // Use cases
  getIt.registerLazySingleton<GetPosts>(
    () => GetPosts(getIt<PostRepository>()),
  );
  getIt.registerLazySingleton<CreatePost>(
    () => CreatePost(getIt<PostRepository>()),
  );

  // Cubits (a fresh instance each time one is requested)
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthService>()));
}
