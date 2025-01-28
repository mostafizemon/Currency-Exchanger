import 'package:currency_exchange/app/currency_exchanger.dart';
import 'package:currency_exchange/features/home/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyExchanger(),
    );
  }
}
