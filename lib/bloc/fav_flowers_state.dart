part of 'fav_flowers_cubit.dart';

@immutable
abstract class FavFlowersState {
  final String errorMessage;
  final List<Flower> flowersList;

  FavFlowersState(this.errorMessage, this.flowersList);
}

class FavFlowersInitial extends FavFlowersState {
  FavFlowersInitial(super.errorMessage, super.flowersList);
}

class FavFlowersFetchLoading extends FavFlowersState {
  FavFlowersFetchLoading(super.errorMessage, super.flowersList) : super();
}

class FavFlowersFetchSuccess extends FavFlowersState {
  FavFlowersFetchSuccess(super.errorMessage, super.flowersList) : super();
}

class FavFlowersFetchFailure extends FavFlowersState {
  FavFlowersFetchFailure(super.errorMessage, super.flowersList) : super();
}
