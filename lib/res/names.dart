import 'package:flutter/material.dart';
import 'package:saborissimo/res/styles.dart';

class Names {
  static final String appName = 'Saboríssimo';
  static final String ordersAppBar = 'Pedidos';
  static final String loginAppBar = 'Iniciar sesión';
  static final String logoutAppBar = 'Cerrar sesión';
  static final String menuAppBar = 'Menú del dia';
  static final String cartAppBar = 'Carrito de pedidos';
  static final String confirmOrderAppBar = 'Confirmar pedido';
  static final String publishMenuAppBar = 'Publicar menu';
  static final String createEntrancesAppBar = 'Entradas';
  static final String createMiddlesAppBar = 'Platos medios';
  static final String createStewsAppBar = 'Platos fuertes';
  static final String createDessertsAppBar = 'Postres';
  static final String createDrinksAppBar = 'Bebidas';
  static final String createMealAppBar = 'Nuevo platillo';

  static final List<Map<String, dynamic>> mealTypeSelector = [
    {
      'value': 'entrada',
      'label': 'Entrada',
      'textStyle': Styles.body(Colors.black),
    },
    {
      'value': 'medio',
      'label': 'Medio',
      'textStyle': Styles.body(Colors.black),
    },
    {
      'value': 'guisado',
      'label': 'Guisado',
      'textStyle': Styles.body(Colors.black),
    },
    {
      'value': 'postre',
      'label': 'Postre',
      'textStyle': Styles.body(Colors.black),
    },
    {
      'value': 'bebida',
      'label': 'Bebida',
      'textStyle': Styles.body(Colors.black),
    },
  ];


}
