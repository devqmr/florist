import 'package:florist/models/orders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  static const screenName = "/order_details_screen";

  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments as Order;
    final shortOrderId = order.id.substring(order.id.length - 8).toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order #$shortOrderId",
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.id.toUpperCase(),
                  style: Theme.of(context).textTheme.headline6),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Text(
                    order.total.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  Text(
                    order.dateTime,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              ...order.items
                  .map(
                    (itm) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(itm.title),
                            Text(
                                "[${(itm.quantity * itm.price).toStringAsFixed(2)}]"),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text("${itm.quantity} pics x \$${itm.price}"),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
