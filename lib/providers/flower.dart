import 'dart:convert';

import 'package:florist/my_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http/intercepted_http.dart';

import '../models/logging_interceptor.dart';
import 'auth.dart';

class Flower with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;
  final interceptedHttp =
  InterceptedHttp.build(interceptors: [LoggingInterceptor()]);

  Flower({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isFavorite,
  });

  Flower copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    double? price,
    bool? isFavorite,
  }) {
    return Flower(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        price: price ?? this.price,
        isFavorite: isFavorite ?? this.isFavorite);
  }

  void _setFavoriteValue(bool fav) {
    isFavorite = fav;
    notifyListeners();
  }

  Future<bool> toggleFavorite() async {
    final oldFavStatus = isFavorite;
    _setFavoriteValue(!isFavorite);

    try {
      final favUserFlowersUrl = Uri.https(MyConstant.FIREBASE_RTDB_URL,
          "/userFavFlowers/${Auth.userAuth?.userId}/$id.json", {"auth": Auth.userAuth?.token});
      final favUserFlowersResponse = await interceptedHttp.put(favUserFlowersUrl, body: json.encode(isFavorite));

      if (favUserFlowersResponse.statusCode >= 400) {
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
