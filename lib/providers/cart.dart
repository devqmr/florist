import 'dart:convert';
import 'package:http/http.dart' as http;
import '../my_constant.dart';
import 'auth.dart';
import 'flower.dart';
import 'package:florist/models/general_exception.dart';
import 'package:flutter/foundation.dart';

class CartFlower with ChangeNotifier {
  late final String id;
  late final String title;
  int quantity = 0;
  late final double price;
  late final String imageUrl;

  CartFlower({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  CartFlower.flower(Flower flower) {
    this.id = flower.id;
    this.title = flower.title;
    this.quantity = 1;
    this.price = flower.price;
    this.imageUrl = flower.imageUrl;
  }
}

class Cart with ChangeNotifier {
  Map<String, CartFlower> _cartFlowers = {};

  double get totalAmount {
    double total = 0.0;

    _cartFlowers.forEach((key, item) {
      total += (item.quantity * item.price);
    });

    return total;
  }

  Future<void> addFlowerToCart(Flower flower) async {
    if (_cartFlowers.containsKey(flower.id)) {
      final currentCartItem = _cartFlowers[flower.id];

      if (currentCartItem == null) {
        throw (GeneralException('Error, Not found flower in cart'));
      }

      final newQuantity = currentCartItem.quantity + 1;

      final url = Uri.https(MyConstant.FIREBASE_RTDB_URL,
          '/cart/ahmed_qamar/${currentCartItem.id}.json');

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

      _cartFlowers.update(currentCartItem.id, (el) {
        return CartFlower(
            id: el.id,
            title: el.title,
            price: el.price,
            imageUrl: el.imageUrl,
            quantity: newQuantity);
      });
    } else {
      // final tempCartItem = _cartFlowers['${flower.id}'];

      try {
        final url = Uri.https(MyConstant.FIREBASE_RTDB_URL,
            '/cart/ahmed_qamar/${flower.id}.json');

        final cartItemJson = json.encode({
          'id': flower.id,
          'title': flower.title,
          'quantity': 1,
          'price': flower.price,
          'imageUrl': flower.imageUrl
        });

        final response = await http.put(url, body: cartItemJson);

        //Don't insert cart item
        if (response.statusCode >= 400) {
          throw (GeneralException(
              'Error, happen while try to add flower to cart'));
        }

        _cartFlowers.putIfAbsent(flower.id, () => CartFlower.flower(flower));
      } catch (e) {
        print(e);
        throw (GeneralException(
            'Error, happen while try to add flower to cart'));
      }
    }

    notifyListeners();
  }

  Future<void> fetchCartItems() async {
    final url =
        Uri.https(MyConstant.FIREBASE_RTDB_URL, '/cart/ahmed_qamar.json', {"auth": Auth.generalTOKEN});

    final response = await http.get(url);

    final responseBody = response.body;

    _cartFlowers.clear();

    if (responseBody.isNotEmpty && responseBody.toLowerCase() != "null") {
      final Map<String, dynamic> cartMap = jsonDecode(responseBody);
      cartMap.forEach((cartItemId, cartItemDate) {
        _cartFlowers.putIfAbsent(
          cartItemId,
          () => CartFlower(
            id: cartItemDate['id'],
            title: cartItemDate['title'],
            price: cartItemDate['price'],
            quantity: int.parse(cartItemDate['quantity'].toString()),
            imageUrl: cartItemDate['imageUrl'] ??
                "https://www.gardeningknowhow.com/wp-content/uploads/2019/09/flower-color-400x391.jpg",
          ),
        );
      });
    }

    notifyListeners();
  }

  List<CartFlower> get cartItems {
    List<CartFlower> cartItemsList = [];
    _cartFlowers.forEach((key, value) {
      cartItemsList.add(value);
    });

    return cartItemsList;
  }

  int getProductQuantity(Flower flower) {
    int qt = 0;

    if (_cartFlowers.containsKey(flower.id)) {
      final currentCartItem = _cartFlowers[flower.id];

      qt = currentCartItem?.quantity ?? 0;
    }

    return qt;
  }

  void removeItem(String id) async {
    final url =
        Uri.https(MyConstant.FIREBASE_RTDB_URL, '/cart/ahmed_qamar/$id.json');

    final response = await http.delete(url);

    print(json.decode(response.body));

    //Don't insert cart item
    if (response.statusCode >= 400) {
      throw (GeneralException(
          'Error, happen while try to add flower to cart!'));
    }

    _cartFlowers.removeWhere((key, value) => key == id);

    notifyListeners();
  }

  void clearCartItems() async {
    _cartFlowers.clear();

    final url =
        Uri.https(MyConstant.FIREBASE_RTDB_URL, '/cart/ahmed_qamar.json');

    final response = await http.delete(url);

    //Don't insert cart item
    if (response.statusCode >= 400) {
      throw (GeneralException('Error, happen while try to clear cart items!'));
    }

    _cartFlowers.clear();
    notifyListeners();
  }
}
