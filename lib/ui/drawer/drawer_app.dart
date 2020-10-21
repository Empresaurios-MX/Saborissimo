import 'package:flutter/material.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/ui/login/login.dart';
import 'package:saborissimo/ui/menu/menu.dart';
import 'package:saborissimo/ui/order/orders.dart';
import 'package:saborissimo/utils/utils.dart';

class DrawerApp extends StatelessWidget {
  final bool logged;

  DrawerApp(this.logged);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Utils.createDrawerHeader(150, Names.appName),
          SizedBox(height: 20),
          createDrawerItem(
              context, Menu(), Icons.restaurant_menu, Names.menuAppBar),
          if (logged)
            createDrawerItem(
                context, Orders(), Icons.shopping_bag, Names.ordersAppBar),
          if (logged)
            createDrawerItem(context, null, Icons.logout, Names.logoutAppBar),
          if (!logged)
            createDrawerItem(context, Login(), Icons.login, Names.loginAppBar),
        ],
      ),
    );
  }

  Widget createDrawerItem(
      BuildContext context, Widget destination, IconData icon, String title) {
    return ListTile(
      onTap: () => Utils.pushRoute(context, destination),
      leading: Icon(
        icon,
        size: 25,
        color: Palette.primary,
      ),
      title: Text(title),
    );
  }
}
