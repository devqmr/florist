import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http_interceptor/http/intercepted_http.dart';
import 'package:meta/meta.dart';

import '../models/general_exception.dart';
import '../models/logging_interceptor.dart';
import '../my_constant.dart';
import '../models/flower.dart';
import 'auth_cubit.dart';

part 'flowers_state.dart';

class FlowersCubit extends Cubit<FlowersState> {
  FlowersCubit() : super(FlowersInitial("", const [], null));

  List<Flower> _flowersList = [];

  final interceptedHttp =
      InterceptedHttp.build(interceptors: [LoggingInterceptor()]);

  void fetchFromServer() async {
    emit(FlowersFetchLoading("", const [], null));

    try {
      final flowersUrl = Uri.https(MyConstant.FIREBASE_RTDB_URL,
          "/flowers.json", {"auth": AuthCubit.userAuth?.token});
      final response = await interceptedHttp.get(flowersUrl);

      final favUserFlowersUrl = Uri.https(
          MyConstant.FIREBASE_RTDB_URL,
          "/userFavFlowers/${AuthCubit.userAuth?.userId}.json",
          {"auth": AuthCubit.userAuth?.token});
      final favUserFlowersResponse =
          await interceptedHttp.get(favUserFlowersUrl);
      final favUserFlowersList =
          jsonDecode(favUserFlowersResponse.body) ?? HashMap();

      print("favUserFlowersList > $favUserFlowersList");
      print(
          "favUserFlowersList with key > ${favUserFlowersList["-NCY_PssakZka7Owlt62"]}");

      Map<String, dynamic> flowersMap = jsonDecode(response.body);

      List<Flower> tempFlowers = [];
      flowersMap.forEach((key, value) {
        tempFlowers.add(Flower(
            id: key,
            title: value['title'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: value['price'],
            isFavorite: favUserFlowersList[key] ?? false));
      });

      //Shuffle images so user see new flowers every time he/she fetch flowers list.
      // tempFlowers.shuffle();

      _flowersList.clear();
      _flowersList.addAll(tempFlowers.reversed);
    } catch (e, stack) {
      print(stack);
      throw (GeneralException("Error!, We can not load flowers..."));
    }

    emit(FlowersFetchSuccess("", [..._flowersList], null));
    // notifyListeners();
  }

  void fetch({bool fresh = false}) async {
    if (_flowersList.isEmpty || fresh) {
      fetchFromServer();
    } else {
      emit(FlowersFetchSuccess("", [..._flowersList], null));
    }
  }

  List<Flower> getFlowers() {
    return [..._flowersList];
  }

  Flower findFlowerById(String id) {
    final index = _flowersList.indexWhere((flw) => flw.id == id);
    return _flowersList[index];
  }

  void updateFavoriteFlowerById(String id, bool newIsFavorite) {
    final index = _flowersList.indexWhere((flw) => flw.id == id);
    _flowersList[index] =
        _flowersList[index].copyWith(isFavorite: newIsFavorite);

    emit(FlowersUpdatesSuccess("", [], null));
  }

  Future<void> addFlower(Flower flower) async {
    final url = Uri.https(MyConstant.FIREBASE_RTDB_URL, "/flowers.json",
        {"auth": AuthCubit.userAuth?.token});

    final flowerJson = json.encode({
      'title': flower.title,
      'description': flower.description,
      'price': flower.price,
      'imageUrl': flower.imageUrl,
      'isFavorite': flower.isFavorite,
    });

    final response = await interceptedHttp.post(url, body: flowerJson);

    final newFlowerId = json.decode(response.body)['name'];

    final newFlower = flower.copyWith(id: newFlowerId);

    emit(FlowersAddSuccess("", [], newFlower));
    _flowersList.add(newFlower);
    fetch();
  }
}
