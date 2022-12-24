import 'package:florist/bloc/fav_flowers_cubit.dart';
import 'package:florist/bloc/flower_cubit.dart';
import 'package:florist/bloc/flowers_cubit.dart';
import 'package:florist/bloc/orders_cubit.dart';
import 'package:florist/screens/auth_screen.dart';
import 'package:florist/screens/flower_details_screen.dart';
import 'package:florist/screens/home_screen.dart';
import 'package:florist/screens/mange_flower.dart';
import 'package:florist/screens/order_details_screen.dart';
import 'package:florist/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'bloc/flower_details_cubit.dart';
import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider(providers: [
    //   ChangeNotifierProvider(create: (_) => Flowers()),
    // ]);

    // MultiPro
    return MultiBlocProvider(
      providers: [
        BlocProvider<FlowersCubit>(
          create: (context) => FlowersCubit(),
        ),
        BlocProvider<FavFlowersCubit>(
          create: (context) =>
              FavFlowersCubit(flowersCubit: context.read<FlowersCubit>()),
        ),
        BlocProvider<FlowerDetailsCubit>(
          create: (context) =>
              FlowerDetailsCubit(flowersCubit: context.read<FlowersCubit>()),
        ),
        BlocProvider<OrdersCubit>(
          create: (context) => OrdersCubit(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProvider(create: (_) => Cart()),
          ChangeNotifierProvider(create: (_) => Orders()),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Florist Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
            ),
            home: auth.isAuthenticated
                ? const HomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoSignIn(),
                    builder: (context, authResultsSnapshot) {
                      if (authResultsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: SplashScreen(),
                        );
                      } else {
                        return const AuthScreen();
                      }
                    },
                  ),
            debugShowCheckedModeBanner: false,
            // initialRoute: '/',
            routes: {
              HomeScreen.screenName: (cxt) => const HomeScreen(),
              FlowerDetailsScreen.screenName: (cxt) =>
                  const FlowerDetailsScreen(),
              OrdersScreen.screenName: (cxt) => const OrdersScreen(),
              OrderDetailsScreen.screenName: (cxt) =>
                  const OrderDetailsScreen(),
              ManageFlower.screenName: (cxt) => const ManageFlower(),
            },
          ),
        ),
      ),
    );
  }
}
