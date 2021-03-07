import 'package:flutter/material.dart';

class TextFieldFilled extends StatelessWidget {
  final String hint;
  final Color theme;
  final Function textListener;
  final Function validator;

  TextFieldFilled({
    this.hint,
    this.theme,
    this.textListener,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        filled: true,
        labelText: hint,
        alignLabelWithHint: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme),
        ),
      ),
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 16, color: Colors.black),
      cursorColor: theme,
      onChanged: (text) => textListener(text),
      validator: (text) => validator != null ? validator(text) : null,
    );
  }
}
