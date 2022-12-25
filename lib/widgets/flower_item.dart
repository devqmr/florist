import 'package:florist/screens/flower_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../app_style.dart';
import '../bloc/cart_cubit.dart';
import '../bloc/flower_cubit.dart';
import '../bloc/flowers_cubit.dart';

class FlowerItem extends StatelessWidget {
  final String flowerId;

  const FlowerItem({Key? key, required this.flowerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FlowerCubit>(
        create: (context) => FlowerCubit(
            flowersCubit: context.read<FlowersCubit>(),
            cartCubit: context.read<CartCubit>(),
            flower: context.read<FlowersCubit>().findFlowerById(flowerId)),
        child: FlowerItemContent());
  }
}

class FlowerItemContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlowerCubit, FlowerState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(FlowerDetailsScreen.screenName,
                arguments: state.flower.id);
          },
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            tag: state.flower.id,
                            child: FadeInImage(
                              image: NetworkImage(state.flower.imageUrl),
                              fit: BoxFit.cover,
                              placeholder: const AssetImage(
                                  'assets/images/placeholder_garden_roses.png'),
                            ),
                          ),
                          if (state.quantityInCart > 0)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                height: 28,
                                width: 28,
                                decoration: const BoxDecoration(
                                    color: Colors.amberAccent,
                                    shape: BoxShape.circle),
                                child: FittedBox(
                                  child: Text(
                                    "${state.quantityInCart}",
                                    style: const TextStyle(
                                      color: Color(0xFF4A148C),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      "${state.flower.title}",
                      style: AppStyle.appFontBold
                          .copyWith(fontSize: 20, color: Colors.purple[600]),
                    ),
                    Container(
                      height: 48,
                      child: Row(
                        children: [
                          FlowerActionWidget(
                            icon: Icon(
                              state.quantityInCart > 0
                                  ? Icons.add
                                  : Icons.shopping_cart,
                              color: Colors.purple[800],
                            ),
                            onPressed: () async {
                              await context
                                  .read<CartCubit>()
                                  .addFlowerToCart(state.flower)
                                  .then((value) => context
                                      .read<FlowerCubit>()
                                      .checkQuantity());
                            },
                          ),
                          FlowerActionWidget(
                            icon: Icon(
                              state.flower.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: Colors.purple[800],
                            ),
                            onPressed: () async {
                              await context
                                  .read<FlowerCubit>()
                                  .toggleFavorite();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FlowerActionWidget extends StatefulWidget {
  const FlowerActionWidget({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

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
