import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:florist/providers/flower.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:meta/meta.dart';

import '../models/logging_interceptor.dart';
import '../my_constant.dart';
import '../providers/auth.dart';

part 'flower_state.dart';

class FlowerCubit extends Cubit<FlowerState> {
  final Flower flower;

  FlowerCubit(this.flower) : super(FlowerInitial(flower, ""));

  final interceptedHttp =
      InterceptedHttp.build(interceptors: [LoggingInterceptor()]);

  Future<void> toggleFavorite() async {
    final oldFavStatus = flower.isFavorite;
    final newFavStatus = !flower.isFavorite;

    try {
      final favUserFlowersUrl = Uri.https(
          MyConstant.FIREBASE_RTDB_URL,
          "/userFavFlowers/${Auth.userAuth?.userId}/${flower.id}.json",
          {"auth": Auth.userAuth?.token});
      final favUserFlowersResponse = await interceptedHttp
          .put(favUserFlowersUrl, body: json.encode(newFavStatus));

      if (favUserFlowersResponse.statusCode >= 400) {
        emit(FlowerToggleFavoriteFailure(
            flower.copyWith(isFavorite: oldFavStatus), "statusCode >= 400"));
      }

      emit(FlowerToggleFavoriteSuccess(
          flower.copyWith(isFavorite: newFavStatus), ""));
    } catch (e) {
      print(e);
      emit(FlowerToggleFavoriteFailure(
          flower.copyWith(isFavorite: oldFavStatus), e.toString()));
    }
  }
}
