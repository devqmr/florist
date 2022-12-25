import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../models/general_exception.dart';
import '../models/logging_interceptor.dart';
import '../my_constant.dart';
import '../providers/auth.dart';
import '../models/cart_flower.dart';
import '../models/orders.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial("", []));

  final interceptedHttp =
      InterceptedHttp.build(interceptors: [LoggingInterceptor()]);

  List<Order> _orderList = [];

  void fetch() async {
    emit(const OrdersFetchLoading("", []));

    await Future.delayed(const Duration(seconds: 1));

    final url = Uri.https(
        MyConstant.FIREBASE_RTDB_URL,
        '/orders/${Auth.userAuth?.userId}.json',
        {"auth": Auth.userAuth?.token});

    final response = await interceptedHttp.get(url);

    if (response.statusCode >= 400) {
      throw (GeneralException('Error, happen while try to fetch orders!'));
    }

    _orderList.clear();

    final dynamic bodyJsonObject = jsonDecode(response.body);
    if (bodyJsonObject == null) {
      throw (GeneralException('Error, happen while try to fetch orders!'));
    }

    final Map<String, dynamic> ordersJson = bodyJsonObject;
    try {
      ordersJson.forEach((key, value) {
            _orderList.add(Order(
                id: key,
                total: double.parse(value['total']),
                dateTime: value['dateTime'],
                items: prepareOrderItems(value['items'])));
          });

      emit(OrderFetchSuccess("", _orderList));

    } catch (e) {
      print(e);
      emit(OrderFetchFailure(e.toString(), []));
    }

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

  Future<bool> createOrder(List<CartFlower> items) async {
    try {
      final url = Uri.https(MyConstant.FIREBASE_RTDB_URL,
          '/orders/${Auth.userAuth?.userId}.json', {"auth": Auth.userAuth?.token});

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

      final response = await interceptedHttp.post(url, body: bodyJson);

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
