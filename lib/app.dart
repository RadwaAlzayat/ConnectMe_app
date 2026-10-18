import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'injection.dart';
import 'persentation/blocs/auth_cubit.dart';
import 'persentation/blocs/auth_state.dart';
import 'persentation/screens/auth_gate.dart';

class ConnectMeApp extends StatelessWidget {
  const ConnectMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The provider sits ABOVE MaterialApp so every screen pushed later by the
    // Navigator can also reach AuthCubit.
    return BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
      child: MaterialApp(
        title: 'ConnectMe',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        // One listener for every auth error message, so no screen repeats
        // this code (and a message never shows twice when two screens are
        // stacked, like Login under Sign Up).
        builder: (context, child) => BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: child ?? const SizedBox.shrink(),
        ),
        home: const AuthGate(),
      ),
    );
  }
}
