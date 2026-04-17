import 'package:flutter/material.dart';

import '../features/products/presentation/pages/product_list_page.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO Refatoração',
      theme: ThemeData(useMaterial3: true),
      home: const ProductListPage(),
    );
  }
}
