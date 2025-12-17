import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shopily/splash_screen.dart';
import 'package:shopily/variables/buyer_vars.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Initialize BuyerPurchaseController globally
    Get.put(BuyerPurchaseController());
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
