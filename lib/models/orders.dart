import 'dart:convert';

import 'package:florist/models/general_exception.dart';
import 'package:florist/my_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_interceptor/http/intercepted_http.dart';

import 'package:intl/intl.dart';

import 'logging_interceptor.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';

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