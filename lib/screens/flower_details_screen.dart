import 'package:florist/bloc/flower_details_cubit.dart';
import 'package:florist/bloc/flowers_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_style.dart';

class FlowerDetailsScreen extends StatefulWidget {
  static const screenName = "/flower_details";

  const FlowerDetailsScreen({Key? key}) : super(key: key);

  @override
  State<FlowerDetailsScreen> createState() => _FlowerDetailsScreenState();
}

class _FlowerDetailsScreenState extends State<FlowerDetailsScreen> {
  bool _needToInit = true;

  @override
  void didChangeDependencies() {
    if (_needToInit) {
      final flowerId = ModalRoute.of(context)!.settings.arguments as String;
      context.read<FlowerDetailsCubit>().findFlowerById(flowerId);

      _needToInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final flower = context.read<FlowersCubit>().findFlowerById(flowerId);
    return BlocBuilder<FlowerDetailsCubit, FlowerDetailsState>(
      builder: (context, state) {
        if (state is FlowerFindSuccess) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                state.flower!.title,
                style: AppStyle.appFontBold.copyWith(fontSize: 30),
              ),
            ),
            body: Center(
                child: Column(
              children: [
                Hero(
                  tag: state.flower!.id,
                  child: Image.network(
                    state.flower!.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        state.flower!.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.purple),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(state.flower!.description,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.purple)),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        child: Text(
                          "\$ ${state.flower!.price}",
                          style: AppStyle.appFontBold.copyWith(fontSize: 30),
                        ),
                        alignment: Alignment.center,
                      )
                    ],
                  ),
                )
              ],
            )),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                state.flower!.title,
                style: AppStyle.appFontBold.copyWith(fontSize: 30),
              ),
            ),
            body: const Center(
              child: Text(
                "Not Match Any FAV State",
              ),
            ),
          );
        }
      },
    );
  }
}
