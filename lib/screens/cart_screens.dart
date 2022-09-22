import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  static const screenName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Cart'),
      ),
    );
  }
}
