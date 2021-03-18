import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Order.dart';
import 'package:saborissimo/data/service/MenuOrderDataService.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/ui/order/order_detail.dart';
import 'package:saborissimo/utils/navigation_utils.dart';
import 'package:saborissimo/utils/preferences_utils.dart';
import 'package:saborissimo/utils/printer.dart';
import 'package:saborissimo/widgets/avatar_chip.dart';
import 'package:saborissimo/widgets/dialog/material_dialog_yes_no.dart';
import 'package:saborissimo/widgets/no_items_message.dart';
import 'package:saborissimo/widgets/rich_popup_menu.dart';

class Orders extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String _token;
  MenuOrderDataService _service;
  List<Order> _orders;

  @override
  void initState() {
    PreferencesUtils.getPreferences()
        .then((preferences) => {
              if (preferences.getString(PreferencesUtils.TOKEN_KEY) != null)
                _token = preferences.getString(PreferencesUtils.TOKEN_KEY)
              else
                _token = ''
            })
        .then((_) => refreshList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(title: Text(DrawerApp.ORDERS), actions: [getActions()]),
      drawer: DrawerApp(),
      body: createList(),
    );
  }

  void refreshList() {
    _service = MenuOrderDataService(_token);
    _service.get().then(
        (response) => setState(() => _orders = response.reversed.toList()));
  }

  void deleteOrders() {
    String token = '';
    MenuOrderDataService service;

    PreferencesUtils.getPreferences().then(
      (preferences) => {
        if (preferences.getBool(PreferencesUtils.LOGGED_KEY) ?? false)
          {
            token = preferences.getString(PreferencesUtils.TOKEN_KEY),
            service = MenuOrderDataService(token),
            service
                .delete()
                .then(
                  (success) => {
                    if (success)
                      refreshList()
                    else
                      Printer.snackBar(
                        widget._scaffoldKey,
                        'Error, inicie sesión e intente de nuevo',
                      )
                  },
                )
                .catchError(
                  (_) => Printer.snackBar(
                    widget._scaffoldKey,
                    'Error, inicie sesión e intente de nuevo',
                  ),
                )
          }
      },
    );
  }

  void actionAdmin(int selected) {
    switch (selected) {
      case 0:
        refreshList();
        break;
      case 1:
        showDialog(
          context: context,
          builder: (_) => MaterialDialogYesNo(
            title: 'Eliminar todos los pedidos',
            body:
                'Esta acción eliminará el registro de todos los pedidos para siempre.',
            positiveActionLabel: 'Eliminar',
            positiveAction: () => {deleteOrders(), Navigator.pop(context)},
            negativeActionLabel: "Cancelar",
            negativeAction: () => Navigator.pop(context),
          ),
        );
        break;
    }
  }

  Widget createList() {
    if (_orders == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Palette.accent),
        ),
      );
    }
    if (_orders.isEmpty) {
      return NoItemsMessage(
        title: 'Sin pedidos',
        subtitle: 'No se han realizado pedidos',
        icon: Icons.search_off,
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
      itemCount: _orders.length,
      itemBuilder: (ctx, index) => createListTile(ctx, _orders[index]),
      separatorBuilder: (context, index) => Divider(thickness: 2),
    );
  }

  Widget createListTile(BuildContext context, Order order) {
    Widget chip;

    if (order.state) {
      chip = AvatarChip(
        label: 'Entregado',
        avatar: Text('✔'),
        theme: Palette.doneLight,
        avatarTheme: Palette.done,
      );
    } else {
      chip = AvatarChip(
        label: 'Sin entregar',
        avatar: Text('✘'),
        theme: Palette.todoLight,
        avatarTheme: Palette.todo,
      );
    }

    return ListTile(
      tileColor: Palette.background,
      title: Text(
        order.client.name,
        style: Styles.subTitle(),
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        order.orderType,
        style: TextStyle(fontSize: 14, color: Colors.black54),
      ),
      trailing: chip,
      onTap: () => NavigationUtils.push(context, OrderDetail(order))
          .then((_) => refreshList()),
    );
  }

  Widget getActions() {
    return RichPopupMenu(
      action: (int selected) => actionAdmin(selected),
      labels: ['Refrescar', 'Borrar todos los pedidos'],
      icons: [Icons.refresh, Icons.delete],
    );
  }
}
