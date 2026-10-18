import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/validators.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_scafold.dart';
import '../widgets/auth_switch_link.dart';
import '../widgets/gradient_button.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    // Runs every validator; stops here if any field is invalid.
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  void _openSignUp() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // Error messages are shown once, app-wide (see app.dart), so this screen
    // only needs the state to know whether the button should show loading.
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AuthScaffold(
          title: 'Welcome back',
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _emailController,
                  hint: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _passwordController,
                  hint: 'Password',
                  isPassword: true,
                  validator: Validators.password,
                ),
                const SizedBox(height: 32),
                GradientButton(
                  label: 'Log In',
                  isLoading: state is AuthLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 16),
                AuthSwitchLink(
                  question: "Don't have an account?",
                  actionLabel: 'Sign up',
                  onPressed: _openSignUp,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
