import 'dart:convert';

import 'package:florist/providers/flower.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../my_constant.dart';

class Flowers with ChangeNotifier {
  List<Flower> flowers = [];

  void fetchFlowers() {
    final url = Uri.https(MyConstant.FIREBASE_RTDB_URL, "/flowers.json");
    http.get(url).then((respone) {
      Map<String, dynamic> mm = jsonDecode(respone.body);
      mm.forEach((key, value) {
        flowers.add(Flower(
            id: key,
            title: value['title'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: value['price'],
            isFavorite: value['isFavorite']));
      });

      notifyListeners();
    });
  }
}
