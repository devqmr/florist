import 'dart:convert';

import 'package:florist/my_constant.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'cart.dart';

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

class Orders extends ChangeNotifier {
  List<Order> _orderList = [];

  void createOrder(List<CartFlower> items) async {
    final url =
        Uri.https(MyConstant.FIREBASE_RTDB_URL, '/orders/ahmed_qamar.json');

    final bodyJson = json.encode({
      "total": "${sumTotalAmount(items)}",
      "dateTime": DateFormat.yMd().add_jm().format(DateTime.now()),
      "items": encodeCartFlower(items)
    });

    final response = await http.post(url, body: bodyJson);

    print("${json.decode(response.body)}");
  }

  double sumTotalAmount(List<CartFlower> items) {
    double total = 0.0;

    for (var item in items) {
      total += (item.quantity * item.price);
    }

    return total;
  }

  List<dynamic> encodeCartFlower(List<CartFlower> items) {
    final List<dynamic> jsonItems = [];

    for (var element in items) {
      jsonItems.add({
        'id': element.id,
        'title': element.title,
        'quantity': element.quantity,
        'price': element.price,
        'imageUrl': element.imageUrl
      });
    }

    return jsonItems;
  }
}
