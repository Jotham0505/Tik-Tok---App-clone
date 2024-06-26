import 'package:flutter/material.dart';
import 'package:tiktok/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isObscure;
  final String labelText;
  final IconData icon;

  const TextInputField({super.key, required this.controller, this.isObscure = false, required this.labelText, required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(fontSize: 20,),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: borderColor,
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: borderColor
          )
        ),
      ),
      obscureText: isObscure,
    );
  }
}