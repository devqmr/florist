import 'package:florist/providers/cart.dart';
import 'package:florist/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const screenName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Container(
      child: Center(
        child: ListView.builder(
          itemBuilder: (ctx, i) {
            return ChangeNotifierProvider.value(
              value: cart.cartItems[i],
              child: CartItem(),
            );
          },
          itemCount: cart.cartItems.length,
        ),
      ),
    );
  }
}
