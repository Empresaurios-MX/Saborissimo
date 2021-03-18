import 'package:flutter/material.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/login/login.dart';
import 'package:saborissimo/ui/meals/meals.dart';
import 'package:saborissimo/ui/memories/memories.dart';
import 'package:saborissimo/ui/menu/daily_menu.dart';
import 'package:saborissimo/ui/order/orders.dart';
import 'package:saborissimo/utils/navigation_utils.dart';
import 'package:saborissimo/utils/preferences_utils.dart';
import 'package:saborissimo/widgets/drawer_title.dart';

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
          DrawerTitle(Names.appName, Palette.primary),
          SizedBox(height: 20),
          drawerTile(DailyMenu(), Icons.menu_book, Names.menuAppBar),
          if (_logged) drawerTile(Meals(), Icons.food_bank, Names.mealsAppBar),
          drawerTile(Memories(), Icons.photo_album, Names.memoriesAppBar),
          if (_logged)
            drawerTile(Orders(), Icons.shopping_bag, Names.ordersAppBar),
          if (_logged) logoutTile(),
          if (!_logged)
            drawerTile(Login(), Icons.login, 'Sección de empleados'),
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

    NavigationUtils.replace(context, DailyMenu());
  }

  Widget logoutTile() {
    return ListTile(
      onTap: () => logOut(),
      leading: Icon(Icons.logout, size: 25, color: Palette.primary),
      title: Text(Names.logoutAppBar, style: Styles.subTitle()),
    );
  }

  Widget drawerTile(Widget destination, IconData icon, String label) {
    return ListTile(
      onTap: () => NavigationUtils.replace(context, destination),
      leading: Icon(icon, size: 25, color: Palette.primary),
      title: Text(label, style: Styles.subTitle()),
    );
  }
}
