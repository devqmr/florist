import 'package:florist/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  const CartItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartFlower = Provider.of<CartFlower>(context);
    return Container(
      child: ListTile(
        leading: Text('${cartFlower.quantity * cartFlower.price}'),
        title: Text(cartFlower.title),
        trailing: Text(cartFlower.quantity.toString()),
        // trailing: Text(cartFlower.price.toString()),
      ),
    );
  }
}
