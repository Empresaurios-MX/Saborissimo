import 'package:flutter/material.dart';

class PhoneFieldEmpty extends StatelessWidget {
  final String hint;
  final Color theme;
  final Function textListener;
  final Function validator;

  PhoneFieldEmpty({
    this.hint,
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
      keyboardType: TextInputType.phone,
      maxLength: 10,
      style: TextStyle(fontSize: 16, color: Colors.black),
      cursorColor: theme,
      onChanged: (text) => textListener(text),
      validator: (text) => validator != null ? validator(text) : null,
    );
  }
}
