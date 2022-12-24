import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../models/flower.dart';
import 'flowers_cubit.dart';

part 'flower_details_state.dart';

class FlowerDetailsCubit extends Cubit<FlowerDetailsState> {
  final FlowersCubit flowersCubit;

  FlowerDetailsCubit({required this.flowersCubit})
      : super(FlowerDetailsInitial("", null));

  void findFlowerById(String id) {
    return emit(FlowerFindSuccess("", flowersCubit.findFlowerById(id)));
  }
}
