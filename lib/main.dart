import 'package:florist/bloc/fav_flowers_cubit.dart';
import 'package:florist/bloc/flowers_cubit.dart';
import 'package:florist/bloc/orders_cubit.dart';
import 'package:florist/screens/auth_screen.dart';
import 'package:florist/screens/flower_details_screen.dart';
import 'package:florist/screens/home_screen.dart';
import 'package:florist/screens/mange_flower.dart';
import 'package:florist/screens/order_details_screen.dart';
import 'package:florist/screens/orders_screen.dart';
import 'package:florist/utils/help_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'bloc/auth_cubit.dart';
import 'bloc/cart_cubit.dart';
import 'bloc/flower_details_cubit.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiPro
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
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
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
      ],
      child: Builder(builder: (context) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {

            HelpUtils.logger.d("[AuthState >> $state]");

            return MaterialApp(
              title: 'Florist Demo',
              theme: ThemeData(
                primarySwatch: Colors.purple,
              ),
              home: context.read<AuthCubit>().isAuthenticated
                  ? const HomeScreen()
                  : FutureBuilder(
                      future: context.read<AuthCubit>().tryAutoSignIn(),
                      builder: (context, authResultsSnapshot) {
                        HelpUtils.logger.d("[AuthState >> FutureBuilder call builder with authResultsSnapshot = $authResultsSnapshot ]");
                        HelpUtils.logger.d("[AuthState >> FutureBuilder call builder with authResultsSnapshot.connectionState = ${authResultsSnapshot.connectionState} ]");

                        if (authResultsSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          HelpUtils.logger.d("[AuthState >> FutureBuilder open SplashScreen");

                          return const Center(
                            child: SplashScreen(),
                          );
                        } else {
                          HelpUtils.logger.d("[AuthState >> FutureBuilder open AuthScreen");

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
            );
          },
        );
      }),
      // child: MultiProvider(
      //   providers: [
      //     ChangeNotifierProvider(create: (_) => Auth()),
      //   ],
      //   child: Consumer<Auth>(
      //     builder: (ctx, auth, _) => ,
      //   ),
      // ),
    );
  }
}
