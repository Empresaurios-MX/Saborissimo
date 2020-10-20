import 'package:flutter/material.dart';
import 'package:saborissimo/res/names.dart';
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
          Utils.createDrawerItem(() => Utils.replaceRoute(context, Menu()),
              Icons.restaurant_menu, Names.menuAppBar),
          if (logged)
            Utils.createDrawerItem(() => Utils.replaceRoute(context, Orders()),
                Icons.shopping_bag_outlined, Names.ordersAppBar),
          if (logged)
            Utils.createDrawerItem(() => Utils.replaceRoute(context, null),
                Icons.logout, Names.logoutAppBar),
          if (!logged)
            Utils.createDrawerItem(() => Utils.replaceRoute(context, Login()),
                Icons.login, Names.loginAppBar),
        ],
      ),
    );
  }
}
