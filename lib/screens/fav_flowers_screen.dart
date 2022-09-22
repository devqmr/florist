import 'package:florist/providers/flowers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/flower_item.dart';

class FavFlowersScreen extends StatelessWidget {
  static const screenName = '/fav_flowers';

  const FavFlowersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favFlowersList = Provider.of<Flowers>(context).favFlowersList;

    return Center(
      child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 4 / 5,
            mainAxisSpacing: 10,
            crossAxisSpacing: 15,
          ),
          itemCount: favFlowersList.length,
          itemBuilder: (context, index) {
            return ChangeNotifierProvider.value(
              value: favFlowersList[index],
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.lightGreenAccent,
                ),
                child: FlowerItem(),
              ),
            );
          }),
    );
  }
}
