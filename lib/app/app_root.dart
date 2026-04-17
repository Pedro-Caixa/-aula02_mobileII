import 'package:flutter/material.dart';

import '../screens/product_list_screen.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO Refatoração',
      theme: ThemeData(useMaterial3: true),
      home: const ProductListScreen(),
    );
  }
}
