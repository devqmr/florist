import 'package:http_interceptor/http/intercepted_http.dart';

import 'logging_interceptor.dart';

class Flower {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final bool isFavorite;
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
}
