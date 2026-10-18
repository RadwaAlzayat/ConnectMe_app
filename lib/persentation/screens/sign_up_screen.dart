import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/validators.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_scafold.dart';
import '../widgets/auth_switch_link.dart';
import '../widgets/gradient_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().signUp(
      fullName: _fullNameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      // AuthGate already shows Home behind this page once the user is
      // signed in; closing this page reveals it.
      listener: (context, state) {
        if (state is Authenticated) Navigator.of(context).pop();
      },
      builder: (context, state) {
        return AuthScaffold(
          title: 'Create account',
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _fullNameController,
                  hint: 'Full name',
                  textCapitalization: TextCapitalization.words,
                  validator: Validators.fullName,
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                AppTextField(
                  controller: _confirmPasswordController,
                  hint: 'Confirm password',
                  isPassword: true,
                  // Compares against what is typed in the password field now.
                  validator: (value) => Validators.confirmPassword(
                    value,
                    _passwordController.text,
                  ),
                ),
                const SizedBox(height: 32),
                GradientButton(
                  label: 'Sign Up',
                  isLoading: state is AuthLoading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 16),
                AuthSwitchLink(
                  question: 'Already have an account?',
                  actionLabel: 'Log in',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
