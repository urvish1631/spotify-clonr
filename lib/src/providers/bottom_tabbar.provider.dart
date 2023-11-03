import 'package:flutter/material.dart';

class BottomTabBarProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex {
    return _currentIndex;
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void clearAllData() {
    _currentIndex = 0;
    notifyListeners();
  }
}