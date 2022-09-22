import 'package:florist/providers/flowers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/florist_collection_screen.dart';

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
        ChangeNotifierProvider(create: (_) => Flowers()),
      ],
      child: MaterialApp(
        title: 'Florist Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          FloristCollectionScreen.ScreenName: (contxt) =>
              FloristCollectionScreen(),
        },
      ),
    );
  }
}
