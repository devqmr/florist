import 'package:flutter/material.dart';

class FloristCollectionScreen extends StatelessWidget {
  static const ScreenName = "/";

  final dummyFlowersList = const [
    "Flower001",
    "Flower002",
    "Flower003",
    "Flower004",
    "Flower005",
    "Flower006",
    "Flower007",
    "Flower008",
    "Flower009",
    "Flower010",
  ];

  const FloristCollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Florist Collection",
        ),
      ),
      body: Container(
        child: GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 4 / 5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 15,
            ),
            itemCount: dummyFlowersList.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.lightGreenAccent,
                ),
                child: Text(
                  dummyFlowersList[index],
                ),
              );
            }),
      ),
    );
  }
}
