import 'package:florist/bloc/orders_cubit.dart';
import 'package:florist/providers/cart.dart';
import 'package:florist/providers/orders.dart';
import 'package:florist/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatefulWidget {
  static const screenName = "/orders_screen";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {



  @override
  void didChangeDependencies() {
    context.read<OrdersCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
        ),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersFetchLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is OrderFetchFailure) {
            return  Center(
              child: Text(state.errorMessage),
            );
          } else if (state is OrderFetchSuccess) {
            return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (cxt, index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                        OrderDetailsScreen.screenName,
                        arguments: state.orders[index]),
                    child: Card(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                state.orders[index]
                                    .id
                                    .substring(state.orders[index].id.length - 8)
                                    .toUpperCase(),
                                style: Theme.of(context).textTheme.headline6),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              children: [
                                Text(
                                  state.orders[index].total.toStringAsFixed(2),
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const Spacer(),
                                Text(
                                  state.orders[index].dateTime,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            ...getFirstThreeFlower(state.orders[index].items),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Container();
          }

        },
      ),
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
