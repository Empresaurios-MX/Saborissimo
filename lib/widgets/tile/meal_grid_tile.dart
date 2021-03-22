import 'package:flutter/material.dart';
import 'package:saborissimo/data/model/Meal.dart';
import 'package:saborissimo/res/palette.dart';
import 'package:saborissimo/res/styles.dart';
import 'package:saborissimo/utils/string_utils.dart';

class MealGridTile extends StatelessWidget {
  final Meal meal;
  final Function goDetail;
  final Function addToCart;
  final Function isSelected;

  MealGridTile({this.meal, this.goDetail, this.addToCart, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () => goDetail(),
            child: Image.network(
              meal.picture,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          if (isSelected())
            Container(
              margin: EdgeInsets.only(bottom: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.check_circle_outline,
                color: Palette.primary,
                size: 50,
              ),
            ),
        ],
      ),
      footer: GridTileBar(
        backgroundColor: Palette.backgroundElevated,
        title: Text(meal.name, style: Styles.subTitle()),
        subtitle: Text(
          meal.type.capitalize(),
          style: TextStyle(color: Colors.black54, fontSize: 15),
        ),
        trailing: GestureDetector(
          onTap: () => addToCart(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(
              Icons.add_shopping_cart,
              color: Palette.primary,
            ),
          ),
        ),
      ),
    );
  }
}
