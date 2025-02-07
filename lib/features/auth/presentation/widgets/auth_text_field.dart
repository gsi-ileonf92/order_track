import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: hint),
      obscureText: obscureText,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$hint is required!";
        }
        return null;
      },
    );
  }
}
