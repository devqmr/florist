import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:florist/bloc/cart_cubit.dart';
import 'package:florist/models/flower.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:meta/meta.dart';

import '../models/logging_interceptor.dart';
import '../my_constant.dart';
import 'auth_cubit.dart';
import 'flowers_cubit.dart';

part 'flower_state.dart';

class FlowerCubit extends Cubit<FlowerState> {
  final Flower flower;
  final FlowersCubit flowersCubit;
  final CartCubit cartCubit;

  FlowerCubit(
      {required this.flowersCubit,
      required this.cartCubit,
      required this.flower})
      : super(FlowerInitial(flower, cartCubit.getProductQuantity(flower), ""));

  final interceptedHttp =
      InterceptedHttp.build(interceptors: [LoggingInterceptor()]);

  Future<void> toggleFavorite() async {
    final quantityInCart = cartCubit.getProductQuantity(flower);

    final oldFavStatus = flower.isFavorite;
    final newFavStatus = !flower.isFavorite;

    try {
      final favUserFlowersUrl = Uri.https(
          MyConstant.FIREBASE_RTDB_URL,
          "/userFavFlowers/${AuthCubit.userAuth?.userId}/${flower.id}.json",
          {"auth": AuthCubit.userAuth?.token});
      final favUserFlowersResponse = await interceptedHttp
          .put(favUserFlowersUrl, body: json.encode(newFavStatus));

      if (favUserFlowersResponse.statusCode >= 400) {
        emit(FlowerToggleFavoriteFailure(
            flower.copyWith(isFavorite: oldFavStatus),
            quantityInCart,
            "statusCode >= 400"));
      }

      flowersCubit.updateFavoriteFlowerById(flower.id, newFavStatus);

      emit(FlowerToggleFavoriteSuccess(
          flower.copyWith(isFavorite: newFavStatus), quantityInCart, ""));
    } catch (e) {
      print(e);
      emit(FlowerToggleFavoriteFailure(
          flower.copyWith(isFavorite: oldFavStatus),
          quantityInCart,
          e.toString()));
    }
  }

  checkQuantity() {
    emit(FlowerUpdateQuantityInitialSuccess(
        flower, cartCubit.getProductQuantity(flower), ""));
  }
}
