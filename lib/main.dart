import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/product_provider.dart';
import 'screens/splash_screen/splash_screen.dart';

void main() {
  runApp(ChangeNotifierProvider<ProductProvider>(
    child: const MySplashScreen(),
    create: (context) => ProductProvider(),
  ));
}
