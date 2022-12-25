import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:florist/bloc/cart_cubit.dart';
import 'package:florist/widgets/flower_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/flowers_cubit.dart';

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
      context.read<CartCubit>().fetchCartItems();

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
      buildWhen: (prev, current) {
        if (current is FlowersUpdatesSuccess) {
          return false;
        } else {
          return true;
        }
      },
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
              context.read<FlowersCubit>().fetch(fresh: true);
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
                  return FlowerItem(
                    key: Key(state.flowersList[index].id),
                    flowerId: state.flowersList[index].id,
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
