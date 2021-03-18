import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/MenuOrder.dart';
import 'package:saborissimo/ui/cart/pay_details.dart';
import 'package:saborissimo/utils/navigation_utils.dart';
import 'package:saborissimo/widgets/meal_list_tile.dart';
import 'package:saborissimo/widgets/no_items_message.dart';

class CartReview extends StatelessWidget {
  final MenuOrder menu;

  CartReview(this.menu);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mi pedido")),
      floatingActionButton: isValidOrder()
          ? FloatingActionButton(
              child: Icon(Icons.arrow_forward),
              onPressed: () => NavigationUtils.push(context, PayDetails(menu)),
            )
          : Container(),
      body: ListView(
        children: [
          if (menu.entrance != null) MealListTile(meal: menu.entrance),
          if (menu.middle != null) MealListTile(meal: menu.middle),
          if (menu.stew != null) MealListTile(meal: menu.stew),
          if (menu.dessert != null) MealListTile(meal: menu.dessert),
          if (menu.drink != null) MealListTile(meal: menu.drink),
          if (!isValidOrder())
            NoItemsMessage(
              title: '!Su pedido esta incompleto!',
              subtitle:
                  'Un pedido completo consta de una entrada, plato medio, guisado y bebida',
              icon: Icons.remove_shopping_cart,
            ),
        ],
      ),
    );
  }

  bool isValidOrder() {
    return menu.entrance != null &&
        menu.middle != null &&
        menu.stew != null &&
        menu.drink != null;
  }
}
