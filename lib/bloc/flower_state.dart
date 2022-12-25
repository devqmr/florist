part of 'flower_cubit.dart';

@immutable
abstract class FlowerState {
  final String errorMessage;
  final Flower flower;
  final int quantityInCart;

  const FlowerState(this.flower, this.quantityInCart, this.errorMessage);
}

class FlowerInitial extends FlowerState {
  FlowerInitial(super.flower, super.quantityInCart, super.errorMessage);
}

class FlowerUpdateQuantityInitialSuccess extends FlowerState {
  FlowerUpdateQuantityInitialSuccess(
      super.flower, super.quantityInCart, super.errorMessage);
}

class FlowerToggleFavoriteSuccess extends FlowerState {
  FlowerToggleFavoriteSuccess(
      super.flower, super.quantityInCart, super.errorMessage);
}

class FlowerToggleFavoriteFailure extends FlowerState {
  FlowerToggleFavoriteFailure(
      super.flower, super.quantityInCart, super.errorMessage);
}
