import 'package:saborissimo/data/model/Address.dart';
import 'package:saborissimo/data/model/Client.dart';
import 'package:saborissimo/data/model/MenuOrder.dart';

class Order {
  final int id;
  final bool state;
  final MenuOrder order;
  final String orderType;
  final String extras;
  final String comments;
  final Address address;
  final Client client;

  Order(
      {this.id,
      this.state,
      this.order,
      this.orderType,
      this.extras,
      this.comments,
      this.address,
      this.client});

  @override
  String toString() {
    return 'Order{id: $id, state: $state, order: $order, orderType: $orderType, extras: $extras, address: $address, client: $client}';
  }
}
