import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:meta/meta.dart';

import '../models/flower.dart';
import '../models/general_exception.dart';
import '../models/logging_interceptor.dart';
import '../my_constant.dart';
import '../providers/auth.dart';
import '../models/cart_flower.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial(0.0, [], ""));

  final interceptedHttp =
      InterceptedHttp.build(interceptors: [LoggingInterceptor()]);

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
          '/cart/${Auth.userAuth?.userId}/${currentCartItem.id}.json');

      final response = await interceptedHttp.patch(
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
            '/cart/${Auth.userAuth?.userId}/${flower.id}.json');

        final cartItemJson = json.encode({
          'id': flower.id,
          'title': flower.title,
          'quantity': 1,
          'price': flower.price,
          'imageUrl': flower.imageUrl
        });

        final response = await interceptedHttp.put(url, body: cartItemJson);

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

    emit(CartFetchSuccess(totalAmount, cartItems, ""));
  }

  Future<void> fetchCartItems() async {
    emit(CartFetchLoading(0.0, [], ""));

    final url = Uri.https(MyConstant.FIREBASE_RTDB_URL,
        '/cart/${Auth.userAuth?.userId}.json', {"auth": Auth.userAuth?.token});

    final response = await interceptedHttp.get(url);

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

      emit(CartFetchSuccess(totalAmount, cartItems, ""));
    } else {
      emit(CartFetchFailure(
          totalAmount, cartItems, "Error while fetch Cart items"));
    }
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
    Uri.https(MyConstant.FIREBASE_RTDB_URL, '/cart/${Auth.userAuth?.userId}/$id.json', {"auth": Auth.userAuth?.token});

    final response = await interceptedHttp.delete(url);

    print(json.decode(response.body));

    //Don't insert cart item
    if (response.statusCode >= 400) {
      throw (GeneralException(
          'Error, happen while try to add flower to cart!'));
    }

    _cartFlowers.removeWhere((key, value) => key == id);
  }

  void clearCartItems() async {
    _cartFlowers.clear();

    final url = Uri.https(MyConstant.FIREBASE_RTDB_URL,
        '/cart/${Auth.userAuth?.userId}.json', {"auth": Auth.userAuth?.token});

    final response = await interceptedHttp.delete(url);

    //Don't insert cart item
    if (response.statusCode >= 400) {
      throw (GeneralException('Error, happen while try to clear cart items!'));
    }

    emit(CartInitial(0.0, [], ""));
  }
}
