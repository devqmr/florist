import 'package:florist/providers/flower.dart';
import 'package:flutter/material.dart';

class FlowerItem extends StatelessWidget {
  final Flower flower;

  const FlowerItem({Key? key, required this.flower}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("${flower.title}"),
    );
  }
}
