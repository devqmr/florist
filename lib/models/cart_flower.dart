import 'flower.dart';

class CartFlower {
  late final String id;
  late final String title;
  int quantity = 0;
  late final double price;
  late final String imageUrl;

  CartFlower({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  CartFlower.flower(Flower flower) {
    id = flower.id;
    title = flower.title;
    quantity = 1;
    price = flower.price;
    imageUrl = flower.imageUrl;
  }
}
