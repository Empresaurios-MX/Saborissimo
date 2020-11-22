import 'package:flutter/material.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/login/login.dart';
import 'package:saborissimo/ui/menu/daily_menu.dart';
import 'package:saborissimo/ui/order/orders.dart';
import 'package:saborissimo/utils/PreferencesUtils.dart';
import 'package:saborissimo/utils/utils.dart';

class DrawerApp extends StatefulWidget {
  @override
  _DrawerAppState createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  bool _logged = false;

  @override
  void initState() {
    PreferencesUtils.getPreferences().then(
          (preferences) => {
        if (preferences.getBool(PreferencesUtils.LOGGED_KEY) ?? false)
          {setState(() => _logged = true)}
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Utils.createDrawerHeader(150, Names.appName),
          SizedBox(height: 20),
          createDrawerItem(
              context, DailyMenu(), Icons.menu_book, Names.menuAppBar),
          if (_logged)
            createDrawerItem(
                context, Orders(), Icons.shopping_bag, Names.ordersAppBar),
          if (_logged) createLogOutDrawerItem(),
          if (!_logged)
            createDrawerItem(
                context, Login(), Icons.login, 'Sección de empleados'),
        ],
      ),
    );
  }

  void logOut() {
    PreferencesUtils.getPreferences().then(
      (preferences) => {
        preferences.setString(
          PreferencesUtils.USER_KEY,
          PreferencesUtils.NULL_VALUE,
        ),
        preferences.setString(
          PreferencesUtils.PASSWORD_KEY,
          PreferencesUtils.NULL_VALUE,
        ),
        preferences.setBool(PreferencesUtils.LOGGED_KEY, false)
      },
    );

    setState(() => _logged = false);

    Utils.replaceRoute(context, DailyMenu());
  }

  Widget createLogOutDrawerItem() {
    return ListTile(
      onTap: () => logOut(),
      leading: Icon(
        Icons.logout,
        size: 25,
        color: Palette.primary,
      ),
      title: Text(Names.logoutAppBar, style: Styles.subTitle(Colors.black)),
    );
  }

  Widget createDrawerItem(
      BuildContext context, Widget destination, IconData icon, String title) {
    return ListTile(
      onTap: () => Utils.replaceRoute(context, destination),
      leading: Icon(
        icon,
        size: 25,
        color: Palette.primary,
      ),
      title: Text(title, style: Styles.subTitle(Colors.black)),
    );
  }
}
