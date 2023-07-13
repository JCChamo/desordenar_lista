import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:list_sortiert/styles/colors.dart';

import '../providers/list_provider.dart';
import '../providers/shared_preferences.dart';

class ButtonRow extends StatefulWidget {
  ButtonRow(this.listProvider, this.callback, {Key? key}) : super(key: key);

  ListProvider? listProvider;
  Function(bool, bool)? callback;

  @override
  State<ButtonRow> createState() => _ButtonRowState();
}

class _ButtonRowState extends State<ButtonRow> {
  Size? size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size!.height * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SaveButton(widget.listProvider, widget.callback),
          ClearButton(widget.callback),
          RandomizeButton(widget.listProvider?.getList(), widget.callback),
        ],
      ),
    );
  }
}

class SaveButton extends StatefulWidget {
  SaveButton(this.listProvider, this.callback, {Key? key}) : super(key: key);

  ListProvider? listProvider;
  Function(bool, bool)? callback;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  Size? size;
  Preferences? prefs;
  Map<String, List<String>>? newSavedLists;

  @override
  void initState() {
    prefs = Preferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final listStrings = widget.listProvider?.getList();
    return SizedBox(
      height: size!.height * 0.06,
      width: size!.width * 0.3,
      child: MaterialButton(
        color: primaryColor20,
        onPressed: () {
          if (listStrings != null && listStrings.isEmpty) {
            Fluttertoast.showToast(msg: 'Añade alguna palabra');
            return;
          }
          final savedLists = prefs?.savedLists;
          newSavedLists = savedLists;
          newSavedLists?.putIfAbsent(
              DateFormat('EEEE dd/MM/y H:mm:ss', 'es').format(DateTime.now()),
              () => listStrings ?? []);
          prefs?.savedLists = newSavedLists;
          // widget.listProvider?.setList([]);
          widget.listProvider?.listStrings = [];
          widget.callback!(true, true);
          Fluttertoast.showToast(msg: 'Lista guardada');
        },
        child: const Text(
          'Guardar',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ClearButton extends StatefulWidget {
  ClearButton(this.callback, {Key? key}) : super(key: key);

  Function(bool, bool)? callback;

  @override
  State<ClearButton> createState() => _ClearButtonState();
}

class _ClearButtonState extends State<ClearButton> {
  Size? size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return ClipRRect(
      child: Container(
        width: size!.width * 0.1,
        height: size!.width * 0.1,
        color: Colors.grey.withOpacity(0.2),
        child: IconButton(
            onPressed: () => widget.callback!(true, true),
            icon: const Icon(Icons.clear)),
      ),
    );
  }
}

class RandomizeButton extends StatefulWidget {
  RandomizeButton(this.listStrings, this.callback, {Key? key})
      : super(key: key);

  List<String>? listStrings;
  Function(bool, bool)? callback;

  @override
  State<RandomizeButton> createState() => _RandomizeButtonState();
}

class _RandomizeButtonState extends State<RandomizeButton> {
  Size? size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SizedBox(
      height: size!.height * 0.06,
      width: size!.width * 0.3,
      child: MaterialButton(
        color: primaryColor20,
        onPressed: () {
          widget.listStrings?.shuffle();
          widget.callback!(true, false);
        },
        child: const Text(
          'Cambiar orden',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
