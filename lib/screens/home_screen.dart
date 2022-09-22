import 'package:florist/screens/cart_screens.dart';
import 'package:florist/screens/fav_flowers_screen.dart';
import 'package:flutter/material.dart';

import 'all_flowers_screen.dart';

class HomeScreen extends StatefulWidget {
  static const screenName = "/";

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _selectedIndex = 0;

  final _tabScreens = [
    AllFlowersScreen(),
    FavFlowersScreen(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Florist Collection",
        ),
      ),
      body: _tabScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            label: 'All',
            icon: Icon(
              Icons.all_inclusive_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Favorite',
            icon: Icon(
              Icons.favorite,
            ),
          ),
          BottomNavigationBarItem(
            label: 'cart',
            icon: Icon(
              Icons.shopping_cart,
            ),
          ),
        ],
      ),
    );
  }
}
