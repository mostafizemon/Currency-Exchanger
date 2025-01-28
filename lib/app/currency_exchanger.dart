import 'package:currency_exchange/features/exchange/ui/exchange.dart';
import 'package:currency_exchange/features/home/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrencyExchanger extends StatelessWidget {
  const CurrencyExchanger({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt _currentIndex = 0.obs;
    List<Widget> screens = [
      HomeScreen(),
      Exchange(),
    ];
    return Scaffold(
        body: Obx(() => screens[_currentIndex.value]),
        bottomNavigationBar: Obx(() {
          return BottomNavigationBar(
            onTap: (index) {
              _currentIndex.value = index;
            },
            currentIndex: _currentIndex.value,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.currency_exchange),
                label: "Exchange",
              ),
            ],
          );
        }));
  }
}
