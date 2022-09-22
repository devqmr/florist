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
        title: Text(
          "Florist Collection",
        ),
      ),
      body: Container(
        child: GridView.builder(
            padding: EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
            ),
            itemCount: dummyFlowersList.length,
            itemBuilder: (context, index) {
              return Text(
                "${dummyFlowersList[index]}",
              );
            }),
      ),
    );
  }
}
