import 'package:flutter/material.dart';

class FloristCollectionScreen extends StatelessWidget {
  static const ScreenName = "/";

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Florist Collection screen',
                ),
              ],
            ),
          ),
        ),
    );
  }
}
