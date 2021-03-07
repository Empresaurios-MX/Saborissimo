import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';

class SelectorFieldEmpty extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final String hint;
  final Color theme;
  final Function textListener;
  final Function validator;

  SelectorFieldEmpty({
    this.options,
    this.hint,
    this.theme,
    this.textListener,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return SelectFormField(
      decoration: InputDecoration(
        labelText: hint,
        alignLabelWithHint: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: theme),
        ),
        suffixIcon: Icon(Icons.arrow_drop_down, color: theme),
      ),
      items: options,
      onChanged: (text) => textListener(text),
      validator: (text) => validator(text),
    );
  }
}
