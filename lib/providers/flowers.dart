import 'dart:convert';

import 'package:florist/providers/flower.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/general_exception.dart';
import '../my_constant.dart';

class Flowers with ChangeNotifier {
  List<Flower> flowers = [];

  Future<void> fetchFlowers() async {
    try {
      final url = Uri.https(MyConstant.FIREBASE_RTDB_URL, "/flowers.json");
      final response = await http.get(url);

      await Future.delayed(const Duration(seconds: 5));

      Map<String, dynamic> mm = jsonDecode(response.body);
      mm.forEach((key, value) {
        flowers.add(Flower(
            id: key,
            title: value['title'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: value['price'],
            isFavorite: value['isFavorite']));
      });
    } catch (e) {
      throw (GeneralException("Error!, We can not load flowers..."));
    }

    notifyListeners();
  }
}
