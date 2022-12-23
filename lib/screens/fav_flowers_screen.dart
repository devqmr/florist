import 'package:florist/bloc/flowers_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/fav_flowers_cubit.dart';
import '../bloc/flower_cubit.dart';
import '../widgets/flower_item.dart';

class FavFlowersScreen extends StatefulWidget {
  static const screenName = '/fav_flowers';

  const FavFlowersScreen({Key? key}) : super(key: key);

  @override
  State<FavFlowersScreen> createState() => _FavFlowersScreenState();
}

class _FavFlowersScreenState extends State<FavFlowersScreen> {
  bool _needToInit = true;

  @override
  void didChangeDependencies() {
    if (_needToInit) {
      context.read<FavFlowersCubit>().fetchFavFlowersList();

      _needToInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavFlowersCubit, FavFlowersState>(
      buildWhen: (prev, current) {
        if (current is FlowersUpdatesSuccess) {
          return false;
        } else {
          return true;
        }
      },
      builder: (context, state) {
        if (state is FavFlowersFetchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is FavFlowersFetchFailure) {
          return Center(
            child: Text(
              "Error >>> ${state.errorMessage}",
            ),
          );
        } else if (state is FavFlowersFetchSuccess) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<FavFlowersCubit>().fetchFavFlowersList();
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
                    create: (context) => FlowerCubit(
                        flowersCubit: context.read<FlowersCubit>(),
                        flower: state.flowersList[index]),
                    child: FlowerItem(),
                  );
                }),
          );
        } else {
          return const Center(
            child: Text(
              "Not Match Any FAV State",
            ),
          );
        }
      },
    );
  }
}
