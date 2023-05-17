import 'package:cookie_buy_cookies/helpers/functions.dart';
import 'package:cookie_buy_cookies/includes/CookieAppBar.dart';
import 'package:cookie_buy_cookies/screens/profile/profile_screen.dart';
import 'package:cookie_buy_cookies/screens/store_screen.dart';
import 'package:flutter/material.dart';

import '../includes/CookieNavigationBar.dart';
import 'transaction/history_screen.dart';
import 'home_screen.dart';

class InitialScreen extends StatefulWidget {
  final int initialIndex;

  const InitialScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  int _selectedIndex = 0;
  double balance = 0.0;

  void onScreenChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _updateBalance();
  }

  createScreenForIndex(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return StoreScreen();
      case 2:
        return HistoryScreen();
      case 3:
        return ProfileScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  void initState() {
    _updateBalance();
    setState(() {
      _selectedIndex = widget.initialIndex;
    });
    super.initState();
  }

  _updateBalance() {
    getBalance().then((value) {
      setState(() {
        balance = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: createScreenForIndex(_selectedIndex),
      bottomNavigationBar: CookieNavigationBar(
        selectedIndex: _selectedIndex,
        onScreenChange: onScreenChange,
      ),
    );
  }
}
