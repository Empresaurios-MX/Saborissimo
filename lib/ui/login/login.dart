import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Login.dart';
import 'package:saborissimo/data/model/LoginResponse.dart';
import 'package:saborissimo/data/service/UserDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/ui/menu/daily_menu.dart';
import 'package:saborissimo/utils/PreferencesUtils.dart';
import 'package:saborissimo/utils/utils.dart';

class Login extends StatefulWidget {
  final _key = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final AdminDataService service = AdminDataService();

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
      key: widget._scaffoldKey,
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

  String _getErrorMessage(empty) {
    if (empty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }

  void validateForm() {
    if (widget._key.currentState.validate()) {
      widget.service
          .login(Admin(_user, _password))
          .catchError((error) => Utils.showSnack(widget._scaffoldKey, "Usuario o contraseña incorrectos"))
          .then((response) => {
                if (response.key != null)
                  saveUserToPreferences(response)
                else
                  Utils.showSnack(
                    widget._scaffoldKey,
                    "Usuario o contraseña incorrectos",
                  )
              });
    }
  }

  void saveUserToPreferences(LoginResponse loginResponse) {
    PreferencesUtils.getPreferences().then((preferences) => {
          preferences.setString(PreferencesUtils.USER_KEY, _user),
          preferences.setString(PreferencesUtils.PASSWORD_KEY, _password),
          preferences.setString(PreferencesUtils.TOKEN_KEY, loginResponse.key),
          preferences.setBool(PreferencesUtils.LOGGED_KEY, true)
        });

    Utils.replaceRoute(context, DailyMenu());
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
