import 'package:florist/providers/flower.dart';
import 'package:florist/screens/flower_details_screen.dart';
import 'package:flutter/material.dart';

class FlowerItem extends StatelessWidget {
  final Flower flower;

  const FlowerItem({Key? key, required this.flower}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(FlowerDetailsScreen.screenName, arguments: flower.id);
      },
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                flower.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Text("${flower.title}"),
          ],
        ),
      ),
    );
  }
}
