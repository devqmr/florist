import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:florist/providers/flower.dart';
import 'package:florist/providers/flowers.dart';
import 'package:florist/providers/orders.dart';
import 'package:florist/widgets/flower_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class AllFlowersScreen extends StatefulWidget {
  static const screenName = "/florist_collection";

  const AllFlowersScreen({Key? key}) : super(key: key);

  @override
  State<AllFlowersScreen> createState() => _AllFlowersScreenState();
}

class _AllFlowersScreenState extends State<AllFlowersScreen> {
  late Flowers _flowersProvider;
  bool _needToInit = true;
  bool _isLoading = false;
  late List<Flower> _flowersList;

  @override
  void didChangeDependencies() {
    if (_needToInit) {
      setState(() => _isLoading = true);

      _flowersProvider = Provider.of<Flowers>(context);

      _flowersProvider.fetchFlowers().then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
        showErrorMessage(e.toString());
      });

      final cartProvider = Provider.of<Cart>(context);
      cartProvider.fetchCartItems();

      final ordersProvider = Provider.of<Orders>(context);
      ordersProvider.fetchOrdersList();

      _needToInit = false;
    }
  }

  void showErrorMessage(String errorMessage) {
    final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
            title: "Error!",
            message: errorMessage,
            contentType: ContentType.failure));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    _flowersList = _flowersProvider.allFlowersList;

    return Container(
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                _flowersProvider.fetchFlowers().catchError((e) {
                  showErrorMessage(e.toString());
                });
              },
              child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 4 / 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 15,
                  ),
                  itemCount: _flowersList.length,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: _flowersList[index],
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.lightGreenAccent,
                        ),
                        child: FlowerItem(),
                      ),
                    );
                  }),
            ),
    );
  }
}
