
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscure;
  final bool readOnly; // ✅ new optional property

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscure = false,
    this.readOnly = false, // ✅ default false
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      readOnly: readOnly, // ✅ now supported
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(), // nice consistent UI
      ),
    );
  }
}

