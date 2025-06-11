import 'package:flutter/material.dart';

class PassField extends StatefulWidget {
  const PassField(
      {super.key,
      required this.controller,
      required this.label,
      required this.validator,});
  final TextEditingController controller;
  final String label;
  final String? Function(String? value) validator;

  @override
  State<PassField> createState() {
    return _PassFieldState();
  }
}

class _PassFieldState extends State<PassField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
          icon: Icon(
            _obscure ? Icons.visibility_off : Icons.visibility,
          ),
        ),
        suffixIconColor: Theme.of(context).colorScheme.onPrimaryContainer,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white54,
          ),
        ),
        errorStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      obscureText: _obscure,
      cursorColor: Colors.white70,
      validator: widget.validator,
    );
  }
}
