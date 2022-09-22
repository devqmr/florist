import 'package:flutter/cupertino.dart';

class FavFlowersScreen extends StatelessWidget {
  static const screenName = '/fav_flowers';

  const FavFlowersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('FavFlowerScreen'),
      ),
    );
  }
}
