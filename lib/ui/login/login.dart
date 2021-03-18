import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Login.dart';
import 'package:saborissimo/data/model/LoginResponse.dart';
import 'package:saborissimo/data/service/UserDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/ui/menu/daily_menu.dart';
import 'package:saborissimo/utils/navigation_utils.dart';
import 'package:saborissimo/utils/preferences_utils.dart';
import 'package:saborissimo/utils/printer.dart';
import 'package:saborissimo/widgets/banner_label.dart';
import 'package:saborissimo/widgets/input/password_field_filled.dart';
import 'package:saborissimo/widgets/input/text_field_filled.dart';
import 'package:saborissimo/widgets/rounded_button.dart';

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
      appBar: AppBar(title: Text('Sección de empleados')),
      drawer: DrawerApp(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 40),
        child: Column(
          children: [
            BannerLabel(Names.appName, Palette.primary),
            SizedBox(height: 40),
            Form(
              key: widget._key,
              child: Column(
                children: [
                  TextFieldFilled(
                    hint: 'Usuario',
                    theme: Palette.primary,
                    textListener: (text) => setState(() => _user = text),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                  SizedBox(height: 10),
                  PasswordFieldFilled(
                    hint: 'Contraseña',
                    hideText: _obscureText,
                    theme: Palette.primary,
                    textListener: (text) => setState(() => _password = text),
                    validator: (text) => _getErrorMessage(text.isEmpty),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            RoundedButton(
              label: Names.loginAppBar,
              color: Palette.primary,
              action: () => validateForm(),
            ),
          ],
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
          .catchError(
            (error) => Printer.snackBar(
              widget._scaffoldKey,
              "Usuario o contraseña incorrectos",
            ),
          )
          .then((response) => {
                if (response.key != null)
                  saveUserToPreferences(response)
                else
                  Printer.snackBar(
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

    NavigationUtils.replace(context, DailyMenu());
  }
}
