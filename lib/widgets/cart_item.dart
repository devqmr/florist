import 'package:florist/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  const CartItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartFlower = Provider.of<CartFlower>(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      child: Dismissible(
        key: ValueKey(cartFlower.id),
        background: Container(
          color: Colors.redAccent,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 36,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text('Remove item'),
                    content: Row(
                      children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                const TextSpan(
                                    text: 'Are you sure want to remove '),
                                TextSpan(
                                    text: cartFlower.title,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold)),
                                const TextSpan(text: '?'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No'),
                      ),
                    ],
                  ));
        },
        onDismissed: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: cartFlower.title,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: ' removed successfully',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        child: Card(
          child: ListTile(
            leading: Text(
                (cartFlower.quantity * cartFlower.price).toStringAsFixed(2)),
            title: Text(cartFlower.title),
            subtitle: Text(cartFlower.quantity.toString()),
            trailing: Image.network(
              cartFlower.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            // trailing: Text(cartFlower.price.toString()),
          ),
        ),
      ),
    );
  }
}
