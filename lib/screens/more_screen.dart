import 'package:florist/providers/auth.dart';
import 'package:florist/screens/mange_flower.dart';
import 'package:florist/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoreScreen extends StatelessWidget {
  static const screenName = "/more_screen";

  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 64,
        horizontal: 32,
      ),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoreScreenItem(
            title: "Your orders",
            icon: Icons.add_card,
            fun: () => Navigator.of(context).pushNamed(OrdersScreen.screenName),
          ),
          SizedBox(
            height: 32,
          ),
          MoreScreenItem(
            title: "Add new Flower",
            icon: Icons.edit_note,
            fun: () => Navigator.of(context).pushNamed(ManageFlower.screenName),
          ),
          SizedBox(
            height: 32,
          ),
          MoreScreenItem(
            title: "About",
            icon: Icons.info,
            fun: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Open About Screen",
                ),
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          MoreScreenItem(
            title: "LogOut",
            icon: Icons.exit_to_app,
            fun: () => authProvider.logout(),
          ),
        ],
      ),
    );
  }
}

class MoreScreenItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function fun;

  const MoreScreenItem(
      {Key? key, required this.title, required this.icon, required this.fun})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        fun();
      },
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.purple[200],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              title,
            ),
          ],
        ),
      ),
    );
  }
}
