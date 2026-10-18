import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Rounded text field from the kit. The look comes from AppTheme; this widget
/// only adds the show/hide toggle for password fields.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool isPassword;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      obscureText: widget.isPassword && _isObscured,
      decoration: InputDecoration(
        hintText: widget.hint,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                ),
                onPressed: () => setState(() => _isObscured = !_isObscured),
              )
            : null,
      ),
    );
  }
}
