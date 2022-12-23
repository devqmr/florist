import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:florist/bloc/flower_cubit.dart';
import 'package:florist/providers/flowers.dart';
import 'package:florist/widgets/flower_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/flowers_cubit.dart';
import '../providers/cart.dart';

class AllFlowersScreen extends StatefulWidget {
  static const screenName = "/florist_collection";

  const AllFlowersScreen({Key? key}) : super(key: key);

  @override
  State<AllFlowersScreen> createState() => _AllFlowersScreenState();
}

class _AllFlowersScreenState extends State<AllFlowersScreen> {
  bool _needToInit = true;

  @override
  void didChangeDependencies() {
    if (_needToInit) {

      context.read<FlowersCubit>().fetch();

      // _flowersProvider = Provider.of<Flowers>(context);
      // _flowersProvider.fetchFlowers().then((value) {
      //
      // }).catchError((e) {
      //
      //   showErrorMessage(e.toString());
      // });

      final cartProvider = Provider.of<Cart>(context);
      cartProvider.fetchCartItems();

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
    return BlocBuilder<FlowersCubit, FlowersState>(
      builder: (context, state) {
        if (state is FlowersFetchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FlowersFetchFailure) {
          return Center(
            child: Text(
              "Error >>> ${state.errorMessage}",
            ),
          );
        } else if (state is FlowersFetchSuccess) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<FlowersCubit>().fetch();
            },
            child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 15,
                ),
                itemCount: state.flowersList.length,
                itemBuilder: (context, index) {
                  return BlocProvider<FlowerCubit>(
                    create: (context) => FlowerCubit(state.flowersList[index]),
                    child: FlowerItem(),
                  );
                }),
          );
        } else {
          return Center(
            child: Text(
              "Not Match Any State [${state}]",
            ),
          );
        }
      },
    );
  }
}
