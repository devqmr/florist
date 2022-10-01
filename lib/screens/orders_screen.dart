import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  static const screenName = "/orders_screen";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Florist Collection",
        ),
      ),
      body: const Center(
        child: Text("orders"),
      ),
    );
  }
}
