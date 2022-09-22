import 'package:florist/providers/flowers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlowerDetailsScreen extends StatelessWidget {
  static const screenName = "/flower_details";

  const FlowerDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flowerId = ModalRoute.of(context)!.settings.arguments as String;
    final flower = Provider.of<Flowers>(context).findFlowerById(flowerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(flower.title),
      ),
      body: Center(
          child: Column(
        children: [
          Image.network(
            flower.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(flower.description),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("\$ ${flower.price}"),
          )
        ],
      )),
    );
  }
}
