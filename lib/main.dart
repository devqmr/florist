import 'package:flutter/material.dart';

import 'screens/florist_collection_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Florist Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        FloristCollectionScreen.ScreenName : (contxt) => FloristCollectionScreen(),
      },
    );
  }
}

