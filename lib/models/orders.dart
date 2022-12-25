import 'cart_flower.dart';

class Order {
  String id = "";
  final double total;
  final String dateTime;
  final List<CartFlower> items;

  Order(
      {required this.id,
      required this.total,
      required this.dateTime,
      required this.items});
}
