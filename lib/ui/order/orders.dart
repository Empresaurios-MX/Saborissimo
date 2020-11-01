import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Order.dart';
import 'package:saborissimo/data/service/OrderDataService.dart';
import 'package:saborissimo/res/names.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/ui/drawer/drawer_app.dart';
import 'package:saborissimo/ui/order/order_detail.dart';
import 'package:saborissimo/utils/utils.dart';

class Orders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Names.ordersAppBar, style: Styles.title(Colors.white)),
        backgroundColor: Palette.primary,
      ),
      drawer: DrawerApp(true),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        itemCount: OrderDataService.orders.length,
        itemBuilder: (ctx, index) =>
            createListTile(ctx, OrderDataService.orders[index]),
/*        separatorBuilder: (context, index) => Divider(
          thickness: 2,
        ),*/
      ),
    );
  }

  Widget createListTile(BuildContext context, Order order) {
    Widget chip = createCrossChip();

    if (order.state) {
      chip = createCheckChip();
    }

    return ListTile(
/*      leading: Icon(
        Icons.shopping_bag_outlined,
        color: Palette.primary,
        size: 35,
      ),*/
      tileColor: Palette.backgroundElevated,
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
      onTap: () => Utils.pushRoute(context, OrderDetail(order)),
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
