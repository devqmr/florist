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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoreScreenItem(
            title: "Your orders",
            icon: Icons.add_card,
            fun: () => Navigator.of(context).pushNamed(OrdersScreen.screenName),
          ),
          MoreScreenItem(
            title: "Add new Flower",
            icon: Icons.edit_note,
            fun: () => Navigator.of(context).pushNamed(ManageFlower.screenName),
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
        color: Colors.amberAccent,
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
