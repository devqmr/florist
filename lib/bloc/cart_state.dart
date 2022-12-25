part of 'cart_cubit.dart';

@immutable
abstract class CartState {
  final double totalAmount;
  final List<CartFlower> cartItems;
  final String errorMessage;

  CartState(this.totalAmount, this.cartItems, this.errorMessage);
}

class CartInitial extends CartState {
  CartInitial(super.totalAmount, super.cartItems, super.errorMessage);
}

class CartFetchLoading extends CartState {
  CartFetchLoading(super.totalAmount, super.cartItems, super.errorMessage);
}

class CartFetchFailure extends CartState {
  CartFetchFailure(super.totalAmount, super.cartItems, super.errorMessage);
}

class CartFetchSuccess extends CartState {
  CartFetchSuccess(super.totalAmount, super.cartItems, super.errorMessage);
}
