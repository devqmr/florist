import 'package:florist/providers/flowers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_style.dart';

class FlowerDetailsScreen extends StatelessWidget {
  static const screenName = "/flower_details";

  const FlowerDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flowerId = ModalRoute.of(context)!.settings.arguments as String;
    final flower = Provider.of<Flowers>(context).findFlowerById(flowerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          flower.title,
          style: AppStyle.appFontBold.copyWith(fontSize: 30),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Hero(
            tag: flower.id,
            child: Image.network(
              flower.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  flower.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.purple),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(flower.description,
                      style:
                          const TextStyle(fontSize: 15, color: Colors.purple)),
                ),
                const SizedBox(height: 20),
                Align(
                  child: Text(
                    "\$ ${flower.price}",
                    style: AppStyle.appFontBold.copyWith(fontSize: 30),
                  ),
                  alignment: Alignment.center,
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
