import 'package:florist/providers/flower.dart';
import 'package:flutter/foundation.dart';

class Flowers with ChangeNotifier {
  List<Flower> flowers = [];

  void fetchFlowers() {
    flowers = [
      Flower(
          id: 'id001',
          title: "Flower 001",
          description: "Nice flower",
          imageUrl:
              "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/diy-paper-flowers-1582662788.jpg",
          price: 3.4,
          isFavorite: false),
      Flower(
          id: 'id002',
          title: "Flower 002",
          description: "Nice flower",
          imageUrl:
              "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/diy-paper-flowers-1582662788.jpg",
          price: 3.4,
          isFavorite: false),
      Flower(
          id: 'id003',
          title: "Flower 003",
          description: "Nice flower",
          imageUrl:
              "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/diy-paper-flowers-1582662788.jpg",
          price: 3.4,
          isFavorite: false),
      Flower(
          id: 'id004',
          title: "Flower 004",
          description: "Nice flower",
          imageUrl:
              "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/diy-paper-flowers-1582662788.jpg",
          price: 3.4,
          isFavorite: false),
      Flower(
          id: 'id005',
          title: "Flower 005",
          description: "Nice flower",
          imageUrl:
              "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/diy-paper-flowers-1582662788.jpg",
          price: 3.4,
          isFavorite: false),
    ];

    notifyListeners();
  }
}
