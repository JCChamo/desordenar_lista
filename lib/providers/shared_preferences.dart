import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instance = Preferences._internal();

  SharedPreferences? _prefs;

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();

  initPrefs() async {
    WidgetsFlutterBinding.ensureInitialized();

    _prefs = await SharedPreferences.getInstance();
  }

  Map<String, List<String>>? get savedLists {
    return savedListsFromJson(_prefs?.getString('saved_lists') ?? '{}');
  }

  set savedLists(Map<String, List<String>>? value) {
    _prefs?.setString('saved_lists', savedListsToJson(value));
  }

  Map<String, List<String>>? savedListsFromJson(String value) =>
      Map.from(json.decode(value)).map((k, v) => MapEntry<String, List<String>>(
          k, List<String>.from(v.map((x) => x))));

  String savedListsToJson(Map<String, List<String>>? data) {
    return json.encode(Map.from(data!).map((k, v) => MapEntry<String, dynamic>(
        k, List<dynamic>.from(v.map((x) => x)))));
  }
}
