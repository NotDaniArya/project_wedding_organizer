import 'package:flutter/material.dart';
import 'package:project_v/app/utils/constants/colors.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.text, required this.onPressed});

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.primaryColor,
        padding: const EdgeInsetsGeometry.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
