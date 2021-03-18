import 'package:flutter/material.dart';

class PasswordFieldEmpty extends StatelessWidget {
  final String hint;
  final bool hideText;
  final Color theme;
  final Function textListener;
  final Function validator;

  PasswordFieldEmpty({
    this.hint,
    this.hideText,
    this.theme,
    this.textListener,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: hint,
        alignLabelWithHint: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme),
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: hideText,
      style: TextStyle(fontSize: 16, color: Colors.black),
      cursorColor: theme,
      onChanged: (text) => textListener(text),
      validator: (text) => validator != null ? validator(text) : null,
    );
  }
}
