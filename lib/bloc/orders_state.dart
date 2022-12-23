part of 'orders_cubit.dart';

@immutable
abstract class OrdersState {
  final String errorMessage;
  final List<Order> orders;

  const OrdersState(this.errorMessage, this.orders);

}

class OrdersInitial extends OrdersState {
  const OrdersInitial(super.errorMessage, super.orders);
}

class OrdersFetchLoading extends OrdersState {
  const OrdersFetchLoading(super.errorMessage, super.orders);

}

class OrderFetchFailure extends OrdersState {
  const OrderFetchFailure(super.errorMessage, super.orders);

}

class OrderFetchSuccess extends OrdersState {
  const OrderFetchSuccess(super.errorMessage, super.orders);

}
