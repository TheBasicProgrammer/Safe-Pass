import 'package:flutter/material.dart';

class NotifController with ChangeNotifier {
  bool _seen = true;
  set setSeen(bool val) {
    _seen = val;
    notifyListeners();
  }
  get getSeen => _seen;
  List<String> _notifs = [];
  List<String> get getNotifs => _notifs;
}