import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/MenuOrder.dart';
import 'package:saborissimo/ui/cart/pay_details.dart';
import 'package:saborissimo/utils/navigation_utils.dart';
import 'package:saborissimo/widgets/meal_list_tile.dart';

class CartReview extends StatelessWidget {
  final MenuOrder menuOrder;

  CartReview(this.menuOrder);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mi pedido")),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () => NavigationUtils.push(context, PayDetails(menuOrder)),
      ),
      body: ListView(
        children: [
          MealListTile(meal: menuOrder.entrance),
          MealListTile(meal: menuOrder.middle),
          MealListTile(meal: menuOrder.stew),
          if (menuOrder.dessert != null) MealListTile(meal: menuOrder.dessert),
          MealListTile(meal: menuOrder.drink),
        ],
      ),
    );
  }
}
