import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../providers/flower.dart';
import 'flowers_cubit.dart';

part 'fav_flowers_state.dart';

class FavFlowersCubit extends Cubit<FavFlowersState> {
  final FlowersCubit flowersCubit;
  late StreamSubscription streamSubscription;

  FavFlowersCubit({required this.flowersCubit})
      : super(FavFlowersInitial("", [])) {
    streamSubscription = flowersCubit.stream.listen((FlowersState state) {
      if (state is FlowersUpdatesSuccess) {
        fetchFavFlowersList();
      }
    });
  }

  void fetchFavFlowersList() {
    emit(FavFlowersFetchSuccess(
        "", flowersCubit.getFlowers().where((fl) => fl.isFavorite).toList()));
  }
}
