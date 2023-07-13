import 'package:flutter/material.dart';
import 'package:list_sortiert/pages/list_page.dart';
import 'package:list_sortiert/providers/list_provider.dart';
import 'package:list_sortiert/styles/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/providers/shared_preferences.dart';

void main() async {
  final prefs = Preferences();
  await prefs.initPrefs();
  runApp(const ListSortiert());
}

class ListSortiert extends StatelessWidget {
  const ListSortiert({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ListProvider(),
        )
      ],
      child: MaterialApp(
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [
          Locale('es'),
        ],
        theme: customTheme.copyWith(
            colorScheme:
                customTheme.colorScheme.copyWith(secondary: primaryColor)),
        debugShowCheckedModeBanner: false,
        home: const ListPage(),
      ),
    );
  }
}
