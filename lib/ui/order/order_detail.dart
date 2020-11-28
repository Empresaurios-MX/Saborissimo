import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/data/model/Order.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';

class OrderDetail extends StatelessWidget {
  final Order order;

  const OrderDetail(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(order.client.name),
        backgroundColor: Palette.primary,
        actions: [createIconButton(context)],
      ),
      floatingActionButton: createFAB(),
      body: ListView(
        children: [
          if (order.menuOrder.entrance != null)
            createListTile(order.menuOrder.entrance, 'Entrada'),
          if (order.menuOrder.middle != null)
            createListTile(order.menuOrder.middle, 'Plato medio'),
          if (order.menuOrder.stew != null)
            createListTile(order.menuOrder.stew, 'Plato fuerte'),
          if (order.menuOrder.dessert != null)
            createListTile(order.menuOrder.dessert, 'Postre'),
          if (order.menuOrder.drink != null)
            createListTile(order.menuOrder.drink, 'Bebida'),
        ],
      ),
    );
  }

  void updateOrder() {
    //order.state = true;
  }

  Widget createFAB() {
    if (order.state) {
      return null;
    }

    return FloatingActionButton(
      child: Icon(Icons.check),
      backgroundColor: Palette.done,
      onPressed: () => updateOrder(),
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
      title: Text(type, style: Styles.subTitle(Colors.black)),
      subtitle: Text(meal.name, style: Styles.bodyWithoutColor()),
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
            Text(text, style: Styles.body(Colors.black))
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
        child: Column(
          children: [
            createInfoRow(Icons.person, 'Nombre', order.client.name),
            createInfoRow(Icons.phone, 'Teléfono', order.client.phone),
            if (order.address.street1.isNotEmpty)
              createInfoRow(Icons.house, 'Calle', order.address.street1),
            if (order.address.street2.isNotEmpty)
              createInfoRow(Icons.house, 'Entre calles', order.address.street2),
            if (order.address.colony.isNotEmpty)
              createInfoRow(Icons.home_work, 'Colonia', order.address.colony),
            if (order.address.references.isNotEmpty)
              createInfoRow(
                Icons.contact_support,
                'Referencias',
                order.address.references,
              ),
            if (order.address.street1.isEmpty)
              createInfoRow(Icons.error, 'Este pedido no es a domicilio', 'Dirección no proporcionado por el cliente')
          ],
        ),
      ),
    );
  }
}
