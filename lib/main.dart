import 'package:florist/providers/flowers.dart';
import 'package:florist/screens/auth_screen.dart';
import 'package:florist/screens/flower_details_screen.dart';
import 'package:florist/screens/home_screen.dart';
import 'package:florist/screens/mange_flower.dart';
import 'package:florist/screens/order_details_screen.dart';
import 'package:florist/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProvider(create: (_) => Flowers()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders()),
      ],
      child: MaterialApp(
        title: 'Florist Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const AuthScreen(),
        debugShowCheckedModeBanner: false,
        // initialRoute: '/',
        routes: {
          HomeScreen.screenName: (cxt) => const HomeScreen(),
          FlowerDetailsScreen.screenName: (cxt) => const FlowerDetailsScreen(),
          OrdersScreen.screenName: (cxt) => const OrdersScreen(),
          OrderDetailsScreen.screenName: (cxt) => const OrderDetailsScreen(),
          ManageFlower.screenName: (cxt) => const ManageFlower(),
        },
      ),
    );
  }
}
