part of 'flowers_cubit.dart';

@immutable
abstract class FlowersState {
  final String errorMessage;
  final List<Flower> flowersList;
  final Flower? flower;

  FlowersState(this.errorMessage, this.flowersList, this.flower);
}

class FlowersInitial extends FlowersState {
  FlowersInitial(super.errorMessage, super.flowersList, super.flower)
      : super();
}

class FlowersFetchLoading extends FlowersState {
  FlowersFetchLoading(super.errorMessage, super.flowersList, super.flower)
      : super();
}

class FlowersFetchSuccess extends FlowersState {
  FlowersFetchSuccess(super.errorMessage, super.flowersList, super.flower)
      : super();
}

class FlowersUpdatesSuccess extends FlowersState {
  FlowersUpdatesSuccess(super.errorMessage, super.flowersList, super.flower)
      : super();
}

class FlowersFetchFailure extends FlowersState {
  FlowersFetchFailure(super.errorMessage, super.flowersList, super.flower)
      : super();
}

class FlowersAddLoading extends FlowersState {
  FlowersAddLoading(super.errorMessage, super.flowersList, super.flower)
      : super();
}

class FlowersAddSuccess extends FlowersState {
  FlowersAddSuccess(super.errorMessage, super.flowersList, super.flower)
      : super();
}

class FlowersAddFailure extends FlowersState {
  FlowersAddFailure(super.errorMessage, super.flowersList, super.flower)
      : super();
}
