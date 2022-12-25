import 'package:florist/bloc/cart_cubit.dart';
import 'package:florist/models/cart_flower.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final CartFlower cartFlower;
  const CartItem({Key? key, required this.cartFlower}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          //Remove item from list
          context.read<CartCubit>().removeItem(cartFlower.id);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: cartFlower.title,
                      style: const TextStyle(
                        color: Colors.amberAccent,
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 150,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.network(
                    cartFlower.imageUrl,
                    width: 125,
                    height: 125,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartFlower.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.purple),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            cartFlower.price.toString(),
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black87),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "x${cartFlower.quantity.toString()}",
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            "${(cartFlower.quantity * cartFlower.price).toStringAsFixed(2)}\$",
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
