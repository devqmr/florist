import 'dart:convert';

import 'package:florist/providers/flower.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/general_exception.dart';
import '../my_constant.dart';

class Flowers with ChangeNotifier {
  List<Flower> flowersList = [];

  Future<void> fetchFlowers() async {
    try {
      final url = Uri.https(MyConstant.FIREBASE_RTDB_URL, "/flowers.json");
      final response = await http.get(url);

      await Future.delayed(const Duration(seconds: 1));

      Map<String, dynamic> flowersMap = jsonDecode(response.body);

      List<Flower> tempFlowers = [];
      flowersMap.forEach((key, value) {
        tempFlowers.add(Flower(
            id: key,
            title: value['title'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: value['price'],
            isFavorite: value['isFavorite']));
      });

      //Shuffle images so user see new flowers every time he/she fetch flowers list.
      tempFlowers.shuffle();

      flowersList.clear();
      flowersList.addAll(tempFlowers);
    } catch (e) {
      throw (GeneralException("Error!, We can not load flowers..."));
    }

    notifyListeners();
  }

  Flower findFlowerById(String id) {
    final index = flowersList.indexWhere((flw) => flw.id == id);

    return flowersList[index];
  }
}
