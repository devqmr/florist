import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:meta/meta.dart';

import '../models/general_exception.dart';
import '../models/logging_interceptor.dart';
import '../my_constant.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';

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
}
