import 'package:flutter/material.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/utils/utils.dart';

class Login extends StatelessWidget {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(Names.loginAppBar),
          backgroundColor: Palette.primary,
        ),
        drawer: DrawerApp(true),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _key,
            child: Column(
              children: [
                Utils.createLoginHeader(100, Names.appName),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      createTextField('Usuario'),
                      createTextField('Contraseña'),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                createRoundedButton(),
              ],
            ),
          ),
        ),
      );

  String _getErrorMessage(empty) {
    if (empty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }

  void validateForm() {
    if (_key.currentState.validate()) {}
  }

  Widget createTextField(String hint) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hint,
      ),
      style: Styles.subTitle(Colors.black),
      validator: (text) => _getErrorMessage(text.isEmpty),
    );
  }

  Widget createRoundedButton() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.all(10),
        child: Text(
          Names.loginAppBar,
          style: Styles.title(Colors.white),
        ),
        color: Palette.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () => validateForm(),
      ),
    );
  }
}
