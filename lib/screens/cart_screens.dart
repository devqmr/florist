import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:florist/bloc/cart_cubit.dart';
import 'package:florist/bloc/orders_cubit.dart';
import 'package:florist/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  static const screenName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    void showSuccessMessage(String errorMessage) {
      final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
              title: "Success!",
              message: errorMessage,
              contentType: ContentType.success));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void onOrderCreated() {
      context.read<CartCubit>().clearCartItems();
      showSuccessMessage('The order has been created successfully ');
    }

    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state is CartFetchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CartFetchFailure) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else if (state is CartFetchSuccess || state is CartInitial) {
          return Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    children: [
                      const Expanded(child: Text('Total')),
                      Text('\$ ${state.totalAmount.toStringAsFixed(2)}'),
                      TextButton(
                        onPressed: () {
                          context
                              .read<OrdersCubit>()
                              .createOrder(state.cartItems)
                              .then((isOrderCreated) =>
                                  isOrderCreated ? onOrderCreated() : {});
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
                    return CartItem(
                      cartFlower: state.cartItems[i],
                    );
                  },
                  itemCount: state.cartItems.length,
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text("Not Match Any State [$state]"),
          );
        }
      },
    );
  }
}
