import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/post_datasource_factory.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/usecases/create_posts.dart';
import 'domain/usecases/get_posts.dart';
import 'persentation/blocs/auth_cubit.dart';
import 'persentation/blocs/post_cubit.dart';
import 'persentation/blocs/profile_cubit.dart';
import 'services/auth_service.dart';
import 'services/biometric_service.dart';
import 'services/device_info_service.dart';
import 'services/firestore_service.dart';
import 'services/photo_picker_service.dart';
import 'services/profile_service.dart';

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
  getIt.registerLazySingleton<ProfileService>(
    () => ProfileService(getIt<FirestoreService>()),
  );
  getIt.registerLazySingleton<BiometricService>(
    () => BiometricService(LocalAuthentication()),
  );
  getIt.registerLazySingleton<DeviceInfoService>(
    () => DeviceInfoService(DeviceInfoPlugin()),
  );
  getIt.registerLazySingleton<PhotoPickerService>(
    () => PhotoPickerService(ImagePicker()),
  );

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
  getIt.registerFactory<PostCubit>(
    () => PostCubit(
      getIt<GetPosts>(),
      getIt<CreatePost>(),
      getIt<ProfileService>(),
    ),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getIt<ProfileService>(),
      getIt<DeviceInfoService>(),
      getIt<PhotoPickerService>(),
      getIt<BiometricService>(),
    ),
  );
}
