import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  //state
  bool _isDarkmode = false;

  //getterr
  bool get isDarkMode => _isDarkmode;

  //functionnya
  //dan notifylistener kasih ntofy pada para pendengar setia!
  void toggleTheme() {
    _isDarkmode = !_isDarkmode;
    notifyListeners();
  }
}
