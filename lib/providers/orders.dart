import 'dart:convert';
import 'dart:ffi';

import 'package:florist/models/general_exception.dart';
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

  Future<bool> createOrder(List<CartFlower> items) async {
    try {
      final url =
          Uri.https(MyConstant.FIREBASE_RTDB_URL, '/orders/ahmed_qamar.json');

      Order tempOrder = Order(
          id: "",
          total: sumTotalAmount(items),
          dateTime: DateFormat.yMd().add_jm().format(DateTime.now()),
          items: items);
      final bodyJson = json.encode({
        "total": "${tempOrder.total}",
        "dateTime": tempOrder.dateTime,
        "items": encodeCartFlower(tempOrder.items)
      });

      final response = await http.post(url, body: bodyJson);

      if (response.statusCode >= 400) {
        throw (GeneralException('Error, happen while try to create order!'));
      }
      print("${json.decode(response.body)}");
      final String orderId = json.decode(response.body)['name'];

      tempOrder.id = orderId;
      _orderList.add(tempOrder);

      return true;
    } catch (e) {
      print(e);
      throw (GeneralException(e.toString()));
    }
  }

  void fetchOrdersList() async {
    final url =
        Uri.https(MyConstant.FIREBASE_RTDB_URL, '/orders/ahmed_qamar.json');

    final response = await http.get(url);

    if (response.statusCode >= 400) {
      throw (GeneralException('Error, happen while try to fetch orders!'));
    }

    _orderList.clear();

    final dynamic bodyJsonObject = jsonDecode(response.body);
    if (bodyJsonObject == null) {
      throw (GeneralException('Error, happen while try to fetch orders!'));
    }

    final Map<String, dynamic> ordersJson = bodyJsonObject;
    ordersJson.forEach((key, value) {
      _orderList.add(Order(
          id: key,
          total: double.parse(value['total']),
          dateTime: value['dateTime'],
          items: prepareOrderItems(value['items'])));
    });

    notifyListeners();
  }

  List<Order> get ordersList {
    return [..._orderList];
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

  prepareOrderItems(List<dynamic> items) {
    final List<CartFlower> tempItems = [];

    for (var fl in items) {
      tempItems.add(CartFlower(
          id: fl['id'],
          title: fl['title'],
          price: fl['price'],
          quantity: fl['quantity'],
          imageUrl: fl['imageUrl']));
    }

    return tempItems;
  }
}
