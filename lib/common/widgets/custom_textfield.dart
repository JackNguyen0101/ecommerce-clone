import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.hintText.toLowerCase() == 'password';
    final optionalFields = ['apt, suite, unit, building'];
    return TextFormField(
      controller: widget.controller,
      obscureText: isPassword ? _obscure : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black38,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
      ),
      validator: (val) {
        if (optionalFields.contains(widget.hintText.toLowerCase())) {
          if (val == null || val.isEmpty) {
            return null;
          }
        }
        if (val == null || val.isEmpty) {
          return "Enter your ${widget.hintText}";
        }
        if (widget.hintText.toLowerCase() == 'email') {
          if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$',
          ).hasMatch(val)) {
            return 'Please enter a valid email address';
          }
        }
        return null;
      },
      maxLines: widget.maxLines,
    );
  }
}
