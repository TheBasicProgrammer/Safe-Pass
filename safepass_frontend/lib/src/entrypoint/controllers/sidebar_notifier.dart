import 'package:flutter/material.dart';

class SidebarNotifier with ChangeNotifier {
  // Change _index to the corresponding index of the screen you're developing.
  // 0 for Dashboard
  // 1 for Logs
  // 2 for Settings
  int _index = 0;
  int get getIndex => _index;
  set setIndex(int index) {
    _index = index;
    notifyListeners();
  }

}