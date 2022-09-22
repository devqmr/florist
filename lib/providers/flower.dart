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

  Future<bool> toggleFavorite() async {
    final oldFavStatus = isFavorite;
    _setFavoriteValue(!isFavorite);

    try {
      final url = Uri.https(MyConstant.FIREBASE_RTDB_URL, '/flowers/$id.json');

      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );

      if (response.statusCode >= 400) {
        _setFavoriteValue(oldFavStatus);
        return false;
      }

      return true;
    } catch (e) {
      print(e);
      _setFavoriteValue(oldFavStatus);
      return false;
    }
  }
}
