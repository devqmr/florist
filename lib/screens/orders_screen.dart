import 'package:florist/providers/cart.dart';
import 'package:florist/providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const screenName = "/orders_screen";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersList = Provider.of<Orders>(context).ordersList;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
        ),
      ),
      body: ListView.builder(
          itemCount: ordersList.length,
          itemBuilder: (cxt, index) {
            return Card(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        ordersList[index]
                            .id
                            .substring(ordersList[index].id.length - 8)
                            .toUpperCase(),
                        style: Theme.of(context).textTheme.headline6),
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Text(
                          ordersList[index].total.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const Spacer(),
                        Text(
                          ordersList[index].dateTime,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ...getFirstThreeFlower(ordersList[index].items),
                  ],
                ),
              ),
            );
          }),
    );
  }

  List<Widget> getFirstThreeFlower(List<CartFlower> cartFlower) {
    List<Widget> flowersList = [];

    var i = 0;
    while (i < 3 && i < cartFlower.length) {
      flowersList.add(
        Text(
          cartFlower[i].title,
        ),
      );
      i++;
    }

    return flowersList;
  }
}
