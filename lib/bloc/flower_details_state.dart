part of 'flower_details_cubit.dart';

@immutable
abstract class FlowerDetailsState {
  final String errorMessage;
  final Flower? flower;

  FlowerDetailsState(this.errorMessage, this.flower);
}

class FlowerDetailsInitial extends FlowerDetailsState {
  FlowerDetailsInitial(super.errorMessage, super.flower);
}

class FlowerFindFailure extends FlowerDetailsState {
  FlowerFindFailure(super.errorMessage, super.flower)
      : super();
}

class FlowerFindSuccess extends FlowerDetailsState {
  FlowerFindSuccess(super.errorMessage, super.flower)
      : super();
}
