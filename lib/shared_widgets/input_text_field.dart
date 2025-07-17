import 'package:flutter/material.dart';

class TInputTextField extends StatelessWidget {
  const TInputTextField({
    super.key,
    required this.labelText,
    required this.inputType,
    this.onSaved,
    this.minLength = 6,
    this.maxLength = 30,
    this.autoCorrect = false,
    this.enableSuggestions = false,
    this.obscureText = false,
  });

  final String labelText;
  final int maxLength;
  final int minLength;
  final TextInputType inputType;
  final bool autoCorrect;
  final bool enableSuggestions;
  final void Function(String? value)? onSaved;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLength: maxLength,
      keyboardType: inputType,
      obscureText: obscureText,
      autocorrect: autoCorrect,
      enableSuggestions: enableSuggestions,
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().length < minLength) {
          return 'Panjang input minimal $minLength karakter';
        }

        return null;
      },
    );
  }
}
