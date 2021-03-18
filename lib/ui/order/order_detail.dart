import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/model/Order.dart';
import 'package:saborissimo/data/service/MenuOrderDataService.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/utils/preferences_utils.dart';
import 'package:saborissimo/utils/printer.dart';
import 'package:saborissimo/widgets/dialog/material_dialog_neutral.dart';
import 'package:saborissimo/widgets/dialog/material_dialog_yes_no.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetail extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final Order _order;

  OrderDetail(this._order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_order.client.name),
        backgroundColor: Palette.primary,
        actions: [createIconButton(context)],
      ),
      floatingActionButton: createFAB(context),
      body: ListView(
        children: [
          if (_order.menuOrder.entrance.id != 0)
            createListTile(_order.menuOrder.entrance, 'Entrada'),
          if (_order.menuOrder.middle.id != 0)
            createListTile(_order.menuOrder.middle, 'Plato medio'),
          if (_order.menuOrder.stew.id != 0)
            createListTile(_order.menuOrder.stew, 'Plato fuerte'),
          if (_order.menuOrder.dessert.id != 0)
            createListTile(_order.menuOrder.dessert, 'Postre'),
          if (_order.menuOrder.drink.id != 0)
            createListTile(_order.menuOrder.drink, 'Bebida'),
        ],
      ),
    );
  }

  void updateOrder(BuildContext context) {
    String token = '';
    MenuOrderDataService service;

    PreferencesUtils.getPreferences().then(
      (preferences) => {
        if (preferences.getBool(PreferencesUtils.LOGGED_KEY) ?? false)
          {
            token = preferences.getString(PreferencesUtils.TOKEN_KEY),
            service = MenuOrderDataService(token),
            _order.state = true,
            service
                .put(_order)
                .then(
                  (success) => {
                    if (success)
                      showDoneDialog(context)
                    else
                      Printer.snackBar(
                        _scaffoldKey,
                        "Error, inicie sesión e intente de nuevo",
                      )
                  },
                )
                .catchError(
                  (_) => Printer.snackBar(
                    _scaffoldKey,
                    "Error, inicie sesión e intente de nuevo",
                  ),
                )
          }
      },
    );
  }

  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showDoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogNeutral('', 'El pedido se ha marcado como entregado.')
    ).then((_) => Navigator.pop(context));
  }

  Widget createFAB(BuildContext context) {
/*    if (_order.state) {
      return Container();
    }*/

    return FloatingActionButton(
      child: Icon(Icons.check),
      backgroundColor: Palette.done,
      onPressed: () => showDialog(
        context: context,
        builder: (_) => MaterialDialogYesNo(
          title: 'Marcar como entregado',
          body: 'Una vez marcado como entregado no se podrá deshacer',
          positiveActionLabel: 'Continuar',
          positiveAction: () => {updateOrder(context), Navigator.pop(context)},
          negativeActionLabel: "Cancelar",
          negativeAction: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget createIconButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.person_pin),
      tooltip: 'Detalles del pedido',
      onPressed: () => showModalBottomSheet(
          context: context, builder: (ctx) => createBottomModal()),
    );
  }

  Widget createListTile(Meal meal, String type) {
    return ListTile(
      leading: Image.network(
        meal.picture,
        height: double.infinity,
        width: 100,
        fit: BoxFit.cover,
      ),
      title: Text(type, style: Styles.subTitle()),
      subtitle: Text(meal.name, style: Styles.body()),
    );
  }

  Widget createInfoRow(IconData icon, String tooltip, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Tooltip(
        message: tooltip,
        child: Row(
          children: [
            Icon(icon, color: Palette.primary),
            SizedBox(width: 20),
            Flexible(child: Text(text, style: Styles.body()))
          ],
        ),
      ),
    );
  }

  Widget createActionRow(IconData icon, String tooltip, String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Tooltip(
        message: tooltip,
        child: Row(
          children: [
            Icon(icon, color: Palette.primary),
            SizedBox(width: 20),
            InkWell(
              onTap: () => makePhoneCall('tel:$text'),
              child: Text(text, style: Styles.body()),
            )
          ],
        ),
      ),
    );
  }

  Widget createBottomModal() {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Palette.backgroundElevated,
        child: Column(
          children: [
            createInfoRow(Icons.person, 'Nombre', _order.client.name),
            createActionRow(Icons.phone, 'Teléfono', _order.client.phone),
            if (_order.extras.isNotEmpty)
              createInfoRow(Icons.add_comment, 'Extras', _order.extras),
            if (_order.comments.isNotEmpty)
              createInfoRow(Icons.comment, 'Comentarios', _order.comments),
            if (_order.address.street1.isNotEmpty)
              createInfoRow(Icons.house, 'Calle', _order.address.street1),
            if (_order.address.street2.isNotEmpty)
              createInfoRow(
                  Icons.house, 'Entre calles', _order.address.street2),
            if (_order.address.colony.isNotEmpty)
              createInfoRow(Icons.home_work, 'Colonia', _order.address.colony),
            if (_order.address.references.isNotEmpty)
              createInfoRow(
                Icons.contact_support,
                'Referencias',
                _order.address.references,
              ),
            if (_order.address.street1.isEmpty)
              createInfoRow(Icons.error, 'Este pedido no es a domicilio',
                  'Dirección no proporcionado por el cliente')
          ],
        ),
      ),
    );
  }
}
