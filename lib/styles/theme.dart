import 'package:flutter/material.dart';
import 'package:list_sortiert/styles/colors.dart';

final customTheme = ThemeData(
    primaryColor: primaryColor,
    indicatorColor: primaryColor,
    hintColor: primaryColor,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: primaryColor20,
      selectionHandleColor: primaryColor,
      cursorColor: primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black, width: 1))));
