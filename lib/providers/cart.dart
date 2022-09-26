import 'dart:convert';

import 'package:florist/models/general_exception.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import '../my_constant.dart';
import 'flower.dart';

class CartFlower with ChangeNotifier {
  late final String cartItemId;
  late final String flowerId;
  late final String title;
  double quantity = 0.0;
  late final double price;
  late final String imageUrl;

  CartFlower({
    required this.cartItemId,
    required this.flowerId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  CartFlower.flower(String cartItemId, Flower flower) {
    this.cartItemId = cartItemId;
    this.flowerId = flower.id;
    this.title = flower.title;
    this.quantity = 1.0;
    this.price = flower.price;
    this.imageUrl = flower.imageUrl;
  }
}

class Cart with ChangeNotifier {
  Map<String, CartFlower> _cartFlowers = {};

  void addFlowerToCart(Flower flower) async {
    if (_cartFlowers.containsKey(flower.id)) {
      final currentCartItem = _cartFlowers['${flower.id}'];

      if (currentCartItem == null) {
        throw (GeneralException('Error, flower not found in the cart'));
      }

      final newQuantity = currentCartItem.quantity + 1;

      final url = Uri.https(MyConstant.FIREBASE_RTDB_URL,
          '/cart/ahmed_qamar/${currentCartItem.cartItemId}.json');

      final response = await http.patch(
        url,
        body: json.encode({
          'quantity': newQuantity,
        }),
      );

      //Don't update cart item
      if (response.statusCode >= 400) {
        throw (GeneralException(
            'Error, happen while try to update flower to quantity'));
      }

      _cartFlowers.update(flower.id, (el) {
        return CartFlower(
            cartItemId: currentCartItem.cartItemId,
            flowerId: el.flowerId,
            title: el.title,
            price: el.price,
            imageUrl: el.imageUrl,
            quantity: newQuantity);
      });
    } else {
      // final tempCartItem = _cartFlowers['${flower.id}'];

      try {
        final url =
            Uri.https(MyConstant.FIREBASE_RTDB_URL, '/cart/ahmed_qamar.json');

        final cartItemJson = json.encode({
          'flowerId': flower.id,
          'title': flower.title,
          'quantity': 1,
          'price': flower.price
        });

        final response = await http.post(url, body: cartItemJson);

        //Don't insert cart item
        if (response.statusCode >= 400) {
          throw (GeneralException(
              'Error, happen while try to add flower to cart'));
        }

        final cartItemId = json.decode(response.body)['name'];
        _cartFlowers.putIfAbsent(
            flower.id, () => CartFlower.flower(cartItemId, flower));
      } catch (e) {
        print(e);
        throw (GeneralException(
            'Error, happen while try to add flower to cart'));
      }
    }
  }

  List<CartFlower> get cartItems {
    List<CartFlower> cartItemsList = [];
    _cartFlowers.forEach((key, value) {
      cartItemsList.add(value);
    });

    return cartItemsList;
  }
}
