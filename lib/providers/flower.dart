import 'dart:convert';

import 'package:florist/my_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Flower with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Flower({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isFavorite,
  });

  void _setFavoriteValue(bool fav) {
    isFavorite = fav;
    notifyListeners();
  }

  void toggleFavorite() async {
    final oldFavStatus = isFavorite;
    _setFavoriteValue(!isFavorite);

    try {
      final url = Uri.https(MyConstant.FIREBASE_RTDB_URL, '/flowers/$id.json');
      print("url > $url");

      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );

      print("response.statusCode > ${response.statusCode}");
      if (response.statusCode >= 400) {
        _setFavoriteValue(oldFavStatus);
      }
    } catch (e) {
      print(e);
      _setFavoriteValue(oldFavStatus);
    }
  }
}
