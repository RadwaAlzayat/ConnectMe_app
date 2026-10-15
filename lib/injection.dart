import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'persentation/blocs/auth_cubit.dart';
import 'services/auth_service.dart';

final getIt = GetIt.instance;

/// The single place where dependencies are wired together.
/// More repositories and use cases are registered here in later steps.
void setupInjection() {
  getIt.registerLazySingleton<AuthService>(
    () => AuthService(FirebaseAuth.instance),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthService>()));
}
