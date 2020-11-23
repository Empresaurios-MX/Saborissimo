import 'package:saborissimo/data/model/Address.dart';
import 'package:saborissimo/data/model/Client.dart';
import 'package:saborissimo/data/model/MenuOrder.dart';
import 'package:saborissimo/data/model/Order.dart';
import 'package:saborissimo/data/service/MenuDataService.dart';

class OrderDataService {
  static final List<MenuOrder> _menuOrders = [
    MenuOrder(
      1,
      MenuDataService.menu.entrances[0],
      MenuDataService.menu.middles[0],
      MenuDataService.menu.stews[0],
      MenuDataService.menu.desserts[0],
      MenuDataService.menu.drinks[0],
    ),
    MenuOrder(
      1,
      MenuDataService.menu.entrances[1],
      MenuDataService.menu.middles[1],
      MenuDataService.menu.stews[1],
      MenuDataService.menu.desserts[1],
      MenuDataService.menu.drinks[0],
    ),
  ];

  static final List<Order> orders = [
    Order(
      id: 0,
      state: true,
      order: _menuOrders[0],
      extras: "",
      comments: "",
      orderType: Order.isOrder,
      address: Address(0, 'Sur 1', 'Norte 12 y Este 10', 'Centro',
          'Casa azul marino'),
      client: Client(0, 'Daniel Antonio Nolasco Alvarado', '2711532828'),
    ),
    Order(
      id: 0,
      state: false,
      order: _menuOrders[1],
      extras: "",
      comments: "",
      orderType: Order.isReserved,
      address: Address(0, '', '', '', ''),
      client: Client(0, 'Fernando Palencia', '2714589896'),
    ),
  ];
}
