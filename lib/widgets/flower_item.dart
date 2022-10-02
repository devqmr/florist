import 'package:florist/providers/cart.dart';
import 'package:florist/providers/flower.dart';
import 'package:florist/screens/flower_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/flowers.dart';

class FlowerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final flower = Provider.of<Flower>(context);
    final flowersProv = Provider.of<Flowers>(context);
    final cartProvider = Provider.of<Cart>(context);

    final _quantityInCart = cartProvider.getProductQuantity(flower);

    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(FlowerDetailsScreen.screenName, arguments: flower.id);
      },
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    flower.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  if (_quantityInCart > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        height: 28,
                        width: 28,
                        decoration: const BoxDecoration(
                            color: Colors.redAccent, shape: BoxShape.circle),
                        child: FittedBox(
                          child: Text(
                            "$_quantityInCart",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text("${flower.title}"),
            Container(
              height: 48,
              child: Row(
                children: [
                  FlowerActionWidget(
                    cartProvider: cartProvider,
                    icon: Icon(
                      _quantityInCart > 0 ? Icons.add : Icons.shopping_cart,
                    ),
                    onPressed: () async {
                      await cartProvider.addFlowerToCart(flower);
                    },
                  ),
                  FlowerActionWidget(
                    cartProvider: cartProvider,
                    icon: Icon(
                      flower.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                    ),
                    onPressed: () async {
                      await flower.toggleFavorite().then((success) => {
                            if (success) {flowersProv.updateFlowersList()}
                          });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FlowerActionWidget extends StatefulWidget {
  const FlowerActionWidget({
    Key? key,
    required this.cartProvider,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final Cart cartProvider;
  final Icon icon;
  final Function onPressed;

  @override
  State<FlowerActionWidget> createState() => _FlowerActionWidgetState();
}

class _FlowerActionWidgetState extends State<FlowerActionWidget> {
  bool isLoading = false;

  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: () async {
            showLoading();
            await widget.onPressed();
            hideLoading();
          },
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : widget.icon,
        ),
      ),
    );
  }
}
