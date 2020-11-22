import 'package:flutter/material.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/ui/menu/daily_menu.dart';
import 'package:saborissimo/utils/PreferencesUtils.dart';
import 'package:saborissimo/utils/utils.dart';

class Login extends StatefulWidget {
  final _key = GlobalKey<FormState>();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _user;
  String _password;
  bool _obscureText = true;

  @override
  void initState() {
    setState(() => {
          _user = '',
          _password = '',
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Names.loginAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
      ),
      drawer: DrawerApp(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: widget._key,
          child: Column(
            children: [
              Utils.createLoginHeader(100, Names.appName),
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: Utils.createHint('Usuario'),
                      style: Styles.subTitle(Colors.black),
                      textAlign: TextAlign.center,
                      onChanged: (value) => setState(() => _user = value),
                      validator: (text) => _getErrorMessage(text.isEmpty),
                    ),
                    TextFormField(
                      decoration: Utils.createHint('Contraseña'),
                      style: Styles.subTitle(Colors.black),
                      textAlign: TextAlign.center,
                      obscureText: _obscureText,
                      onChanged: (value) => setState(() => _password = value),
                      validator: (text) => _getErrorMessage(text.isEmpty),
                    ),
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
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String _getErrorMessage(empty) {
    if (empty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }

  void validateForm() {
    if (widget._key.currentState.validate()) {
      // Make request

      if (_user == 'admin' && _password == 'admin') {
        PreferencesUtils.getPreferences().then(
          (preferences) => {
            preferences.setString(PreferencesUtils.USER_KEY, _user),
            preferences.setString(PreferencesUtils.PASSWORD_KEY, _password),
            preferences.setBool(PreferencesUtils.LOGGED_KEY, true)
          },
        );

        Utils.replaceRoute(context, DailyMenu());
      }
    }
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
