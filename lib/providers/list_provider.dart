import 'package:flutter/material.dart';

class ListProvider extends ChangeNotifier {
  List<String>? listStrings;

  ListProvider() {
    listStrings = <String>[];
  }

  List<String>? getList() => listStrings;

  setList(List<String>? listStrings) {
    this.listStrings = listStrings;
    notifyListeners();
  }
}