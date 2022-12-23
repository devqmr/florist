part of 'flower_cubit.dart';

@immutable
abstract class FlowerState {
  final String errorMessage;
  final Flower flower;

  const FlowerState(this.flower, this.errorMessage);
}

class FlowerInitial extends FlowerState {
  FlowerInitial(super.flower, super.errorMessage);
}

class FlowerToggleFavoriteSuccess extends FlowerState {
  FlowerToggleFavoriteSuccess(super.flower, super.errorMessage);
}

class FlowerToggleFavoriteFailure extends FlowerState {
  FlowerToggleFavoriteFailure(super.flower, super.errorMessage);
}
