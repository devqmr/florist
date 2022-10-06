import 'dart:convert';

import 'package:florist/providers/flower.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/general_exception.dart';
import '../my_constant.dart';

class Flowers with ChangeNotifier {
  List<Flower> _flowersList = [];

  Future<void> fetchFlowers() async {
    try {
      final url = Uri.https(MyConstant.FIREBASE_RTDB_URL, "/flowers.json");
      final response = await http.get(url);


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

      _flowersList.clear();
      _flowersList.addAll(tempFlowers);
    } catch (e) {
      throw (GeneralException("Error!, We can not load flowers..."));
    }

    notifyListeners();
  }

  List<Flower> get allFlowersList {
    //Return copy list not the original list
    return [..._flowersList];
  }

  List<Flower> get favFlowersList {
    //Return copy list not the original list
    return _flowersList.where((fl) => fl.isFavorite).toList();
  }

  Flower findFlowerById(String id) {
    final index = _flowersList.indexWhere((flw) => flw.id == id);
    return _flowersList[index];
  }

  void updateFlowersList() {
    notifyListeners();
  }

  Future<void> addFlower(Flower flower) async {
    final url = Uri.https(MyConstant.FIREBASE_RTDB_URL, "/flowers.json");

    final flowerJson = json.encode({
      'title': flower.title,
      'description': flower.description,
      'price': flower.price,
      'imageUrl': flower.imageUrl,
      'isFavorite': flower.isFavorite,
    });

    final response = await http.post(url, body: flowerJson);

    final newFlowerId = json.decode(response.body)['name'];

    final newFlower = flower.copyWith(id: newFlowerId);

    _flowersList.add(newFlower);

    notifyListeners();
  }
}
