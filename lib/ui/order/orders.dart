import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Order.dart';
import 'package:saborissimo/data/service/MenuOrderDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/ui/order/order_detail.dart';
import 'package:saborissimo/utils/PreferencesUtils.dart';
import 'package:saborissimo/utils/utils.dart';

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
      appBar: AppBar(
        title: Text(Names.ordersAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
        actions: [createDeleteButton(), createRefreshButton()],
      ),
      drawer: DrawerApp(),
      body: createList(),
    );
  }

  void refreshList() {
    _service = MenuOrderDataService(_token);
    _service.get().then((response) => setState(() => _orders = response.reversed.toList()));
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
                      Utils.showSnack(
                        widget._scaffoldKey,
                        'Error, inicie sesión e intente de nuevo',
                      )
                  },
                )
                .catchError(
                  (_) => Utils.showSnack(
                    widget._scaffoldKey,
                    'Error, inicie sesión e intente de nuevo',
                  ),
                )
          }
      },
    );
  }

  void showDeleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          'Borrar el menú del día, ¿Está de acuerdo?',
          textAlign: TextAlign.center,
          style: Styles.subTitle(Colors.black),
        ),
        content: Icon(
          Icons.warning,
          color: Palette.todo,
          size: 80,
        ),
        actions: [
          FlatButton(
            onPressed: () => {deleteOrders(), Navigator.pop(context)},
            child: Text("Sí"),
            textColor: Palette.primary,
          ),
          FlatButton(
            onPressed: () => {Navigator.pop(context)},
            child: Text("No"),
            textColor: Palette.primary,
          ),
        ],
      ),
    );
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
      return Center(
        child: Utils.createNoItemsMessage(
          'No se han realizado pedidos',
        ),
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
    Widget chip = createCrossChip();

    if (order.state) {
      chip = createCheckChip();
    }

    return ListTile(
      tileColor: Palette.background,
      title: Text(
        order.client.name,
        style: Styles.subTitle(Colors.black),
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        order.orderType,
        style: Styles.bodyWithoutColor(),
      ),
      trailing: chip,
      onTap: () => Utils.pushRoute(context, OrderDetail(order))
          .then((_) => refreshList()),
    );
  }

  Widget createDeleteButton() {
    return IconButton(
      icon: Icon(Icons.delete_forever),
      tooltip: 'Borrar menú',
      onPressed: () => showDeleteDialog(),
    );
  }

  Widget createRefreshButton() {
    return IconButton(
      icon: Icon(Icons.refresh),
      tooltip: 'Refrescar',
      onPressed: () => refreshList(),
    );
  }

  Widget createCheckChip() {
    return Chip(
      backgroundColor: Palette.doneLight,
      avatar: CircleAvatar(
        backgroundColor: Palette.done,
        foregroundColor: Colors.white,
        child: Text('✔'),
      ),
      label: Text(
        'Entregado',
        style: Styles.body(Colors.black),
      ),
    );
  }

  Widget createCrossChip() {
    return Chip(
      backgroundColor: Palette.todoLight,
      avatar: CircleAvatar(
        backgroundColor: Palette.todo,
        foregroundColor: Colors.white,
        child: Text('✘'),
      ),
      label: Text(
        'Sin entregar',
        style: Styles.body(Colors.black),
      ),
    );
  }
}
