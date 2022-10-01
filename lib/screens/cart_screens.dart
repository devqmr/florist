import 'package:florist/providers/cart.dart';
import 'package:florist/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  static const screenName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _needToInit = true;

  @override
  void didChangeDependencies() {
    if (_needToInit) {
      // final carttt = Provider.of<Cart>(context);
      // carttt.fetchCartItems();

      _needToInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<Cart>(context);
    final _ordersProvider = Provider.of<Orders>(context);

    return Column(
      children: [
        Card(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              children: [
                const Expanded(child: Text('Total')),
                Text('\$ ${_cartProvider.totalAmount.toStringAsFixed(2)}'),
                TextButton(
                  onPressed: () {
                    _ordersProvider.createOrder(_cartProvider.cartItems);
                  },
                  child: const Text('Order Now'),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, i) {
              return ChangeNotifierProvider.value(
                value: _cartProvider.cartItems[i],
                child: const CartItem(),
              );
            },
            itemCount: _cartProvider.cartItems.length,
          ),
        ),
      ],
    );
  }
}
