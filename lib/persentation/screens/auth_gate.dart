import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';
import '../blocs/post_cubit.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// Decides which screen to show from the auth state. This is what skips the
/// login screen when the user is already signed in.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      // `sealed` states: the compiler checks every case is handled.
      builder: (context, state) => switch (state) {
        AuthInitial() => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        // PostCubit lives only while signed in: on logout this provider is
        // removed, the cubit closes and its Firestore listener stops.
        Authenticated(:final user) => BlocProvider<PostCubit>(
          create: (_) => getIt<PostCubit>()..watchPosts(),
          child: HomeScreen(user: user),
        ),
        // Loading and error stay on the login screen so the form keeps its text.
        Unauthenticated() ||
        AuthLoading() ||
        AuthError() => const LoginScreen(),
      },
    );
  }
}
