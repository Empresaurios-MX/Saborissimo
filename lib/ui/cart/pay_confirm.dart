import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Order.dart';
import 'package:saborissimo/data/service/MenuOrderDataService.dart';
import 'package:saborissimo/ui/menu/daily_menu.dart';
import 'package:saborissimo/utils/navigation_utils.dart';
import 'package:saborissimo/widgets/label/body_label.dart';
import 'package:saborissimo/widgets/label/column_label.dart';
import 'file:///C:/Users/daniel/Documents/AndroidStudio/saborissimo/lib/widgets/dialog/material_dialog_neutral.dart';

class PayConfirm extends StatelessWidget {
  final Order order;

  PayConfirm(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Revisar pedido')),
      floatingActionButton: MakeOrderButton(order),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ColumnLabel(label: 'Nombre', text: order.client.name),
              ColumnLabel(label: 'Teléfono', text: order.client.phone),
              ColumnLabel(
                  label: 'Extras',
                  text: order.extras.isEmpty ? 'Sin extras' : order.extras),
              ColumnLabel(
                  label: 'Comentarios',
                  text: order.comments.isEmpty
                      ? 'Sin comentarios'
                      : order.comments),
              ...createAddressRows()
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createAddressRows() {
    List<Widget> rows = [
      SizedBox(height: 15),
      BodyLabel(
        '* Usted esta realizando un apartado, por lo tanto, usted debe acudir personalmente a nuestro local a recoger su pedido.',
      ),
    ];

    if (order.orderType == Order.isOrder) {
      rows = [
        ColumnLabel(label: 'Calle', text: order.address.street1),
        ColumnLabel(label: 'Entre calles', text: order.address.street2),
        ColumnLabel(label: 'Colonia', text: order.address.colony),
        ColumnLabel(
            label: 'Referencias',
            text: order.address.references.isEmpty
                ? 'Sin referencias'
                : order.address.references),
      ];
    }

    return rows;
  }
}

class MakeOrderButton extends StatefulWidget {
  final Order order;

  MakeOrderButton(this.order);

  @override
  _MakeOrderButtonState createState() => _MakeOrderButtonState();
}

class _MakeOrderButtonState extends State<MakeOrderButton> {
  bool _working;

  @override
  void initState() {
    _working = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: getIcon(),
      onPressed: () => startWork(),
    );
  }

  void startWork() {
    if (_working) {
      return;
    }
    MenuOrderDataService service = MenuOrderDataService("");

    setState(() => _working = true);
    service.post(widget.order).then(
        (success) => {if (success) showDoneDialog() else showErrorMessage()});
  }

  void showDoneDialog() {
    showDialog(
      context: context,
      builder: (_) => MaterialDialogNeutral('', 'Pedido realizado con exito.'),
    ).then((_) => NavigationUtils.popAndReplace(context, DailyMenu()));
  }

  void showErrorMessage() {
    setState(() => _working = false);

    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text('Ha ocurrido un error, intente de nuevo')),
    );
  }

  Widget getIcon() {
    if (_working) {
      return Padding(
        padding: EdgeInsets.all(15),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
          strokeWidth: 2,
        ),
      );
    }

    return Icon(Icons.send);
  }
}
