import 'package:flutter/material.dart';
import 'package:saborissimo/res/styles.dart';

class Names {
  static final String appName = 'Saboríssimo';
  static final String memoriesAppBar = 'Recuerdos';
  static final String ordersAppBar = 'Pedidos';
  static final String mealsAppBar = 'Platillos';
  static final String loginAppBar = 'Iniciar sesión';
  static final String logoutAppBar = 'Cerrar sesión';
  static final String menuAppBar = 'Menú del dia';
  static final String cartAppBar = 'Carrito de pedidos';
  static final String confirmOrderAppBar = 'Confirmar pedido';
  static final String publishMenuAppBar = 'Publicar menú';
  static final String createEntrancesAppBar = 'Seleccione las entradas';
  static final String createMiddlesAppBar = 'Seleccione los platos medios';
  static final String createStewsAppBar = 'Seleccione los platos fuertes';
  static final String createDessertsAppBar = 'Seleccione los postres';
  static final String createDrinksAppBar = 'Seleccione las bebidas';
  static final String createMealAppBar = 'Nuevo platillo';
  static final String createMemoryAppBar = 'Publicar nuevo recuerdo';

  static final List<Map<String, dynamic>> mealTypeSelector = [
    {
      'value': 'entrada',
      'label': 'Entrada',
      'textStyle': Styles.body(),
    },
    {
      'value': 'medio',
      'label': 'Medio',
      'textStyle': Styles.body(),
    },
    {
      'value': 'guisado',
      'label': 'Fuerte',
      'textStyle': Styles.body(),
    },
    {
      'value': 'postre',
      'label': 'Postre',
      'textStyle': Styles.body(),
    },
    {
      'value': 'bebida',
      'label': 'Bebida',
      'textStyle': Styles.body(),
    },
  ];


}
