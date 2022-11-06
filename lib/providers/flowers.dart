import 'dart:collection';
import 'dart:convert';

import 'package:florist/providers/auth.dart';
import 'package:florist/providers/flower.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/general_exception.dart';
import '../my_constant.dart';

class Flowers with ChangeNotifier {
  String token;

  Flowers(this.token, this._flowersList);

  List<Flower> _flowersList = [];

  Future<void> fetchFlowers() async {
    try {
      final flowersUrl = Uri.https(
          MyConstant.FIREBASE_RTDB_URL, "/flowers.json", {"auth": token});
      final response = await http.get(flowersUrl);

      final favUserFlowersUrl = Uri.https(MyConstant.FIREBASE_RTDB_URL,
          "/userFavFlowers/${Auth.userAuth?.userId}.json", {"auth": token});
      final favUserFlowersResponse = await http.get(favUserFlowersUrl);
      final favUserFlowersList = jsonDecode(favUserFlowersResponse.body) ?? HashMap();

      print("favUserFlowersList > $favUserFlowersList");
      print("favUserFlowersList with key > ${favUserFlowersList["-NCY_PssakZka7Owlt62"]}");

      Map<String, dynamic> flowersMap = jsonDecode(response.body);

      List<Flower> tempFlowers = [];
      flowersMap.forEach((key, value) {
        tempFlowers.add(Flower(
            id: key,
            title: value['title'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: value['price'],
            isFavorite: favUserFlowersList[key] ?? false));
      });

      //Shuffle images so user see new flowers every time he/she fetch flowers list.
      tempFlowers.shuffle();

      _flowersList.clear();
      _flowersList.addAll(tempFlowers);
    } catch (e, stack) {
      print(stack);
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
    final url = Uri.https(
        MyConstant.FIREBASE_RTDB_URL, "/flowers.json", {"auth": token});

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
