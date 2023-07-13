import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:list_sortiert/providers/list_provider.dart';

import '../providers/shared_preferences.dart';
import '../styles/styles.dart';
import '../widgets/widgets.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Size? size;
  TextEditingController? _inputController;
  List<String>? listStrings;
  ListProvider? listProvider;
  Function(bool, bool)? callback;
  Preferences? prefs;
  UniqueKey? dismissibleKey;

  @override
  void initState() {
    _inputController = TextEditingController();
    listProvider = ListProvider();
    listStrings = listProvider?.getList();
    prefs = Preferences();
    dismissibleKey = UniqueKey();
    callback = (v, wipeData) => {
          if (wipeData)
            {listStrings = [], listProvider?.listStrings = listStrings},
          if (v) {setState(() {})},
          listStrings = listProvider?.getList()
        };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: getBody(size!.height - size!.height * 0.09,
              size!.width - size!.width * 0.1)),
    );
  }

  getBody(double height, double width) {
    return Center(
        child: Padding(
      padding: EdgeInsets.symmetric(
          vertical: size!.height * 0.03, horizontal: size!.width * 0.05),
      child: SizedBox(
        height: height,
        width: width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getTextFormFieldContainer(width),
                SizedBox(
                  height: size!.height * 0.15,
                ),
                getRecoverButton()
              ],
            ),
            ButtonRow(listProvider, callback),
            getListViewContainer(),
          ],
        ),
      ),
    ));
  }

  SizedBox getTextFormFieldContainer(double width) => SizedBox(
      width: width * 0.8,
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
          controller: _inputController,
          style: TextStyle(fontSize: size!.width * 0.05),
          onFieldSubmitted: (value) {
            if (value.length < 3) return;
            listStrings?.add(value);
            listProvider?.listStrings = listStrings;
            setState(() {});
            _inputController?.clear();
          },
          onEditingComplete: () {}));

  getListViewContainer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(8)),
        height: size!.height * 0.65,
        width: size!.width * 0.85,
        child: ListView.separated(
          separatorBuilder: (_, __) => SizedBox(
            height: size!.height * 0.03,
          ),
          itemCount: listStrings!.length,
          itemBuilder: (BuildContext context, int index) {
            return ListViewItem(listStrings?[index]);
          },
          padding: EdgeInsets.symmetric(
            horizontal: size!.width * 0.05,
            vertical: size!.width * 0.05,
          ),
        ),
      ),
    );
  }

  getRecoverButton() {
    return ClipRRect(
      child: Container(
        width: size!.width * 0.1,
        height: size!.width * 0.1,
        color: Colors.grey.withOpacity(0.2),
        child: IconButton(
            onPressed: () {
              if (prefs!.savedLists!.isNotEmpty) {
                showSavedListsDialog();
              } else {
                Fluttertoast.showToast(msg: 'No hay listas guardadas');
              }
            },
            icon: const Icon(Icons.arrow_back)),
      ),
    );
  }

  showSavedListsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                  contentPadding: const EdgeInsets.all(0),
                  titlePadding: const EdgeInsets.all(0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  content: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: size!.height * 0.05,
                        horizontal: size!.width * 0.05),
                    width: size!.width * 0.8,
                    height: size!.height * 0.6,
                    child: ListView.builder(
                      itemCount: prefs?.savedLists?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final key = prefs?.savedLists?.keys.elementAt(index);
                        final firstElement =
                            prefs?.savedLists?.values.elementAt(index)[0];
                        return GestureDetector(
                            onLongPress: () {
                              listProvider?.listStrings =
                                  prefs?.savedLists?[key];
                              callback!(true, false);
                              Navigator.pop(context);
                            },
                            child: ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                child: Dismissible(
                                  onDismissed: (direction) =>
                                      removeElement(key),
                                  background: Container(
                                      color: Colors.red,
                                      child: const Center(
                                        child: Text(
                                          'ELIMINAR',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                  key: dismissibleKey!,
                                  child: ListViewItem('$key  - $firstElement'),
                                )));
                      },
                    ),
                  ));
            },
          );
        });
  }

  removeElement(String? key) {
    Map<String, List<String>>? newSavedLists = prefs?.savedLists!;
    newSavedLists?.remove(key);
    prefs?.savedLists = newSavedLists;
    if (prefs!.savedLists!.isEmpty) Navigator.pop(context);
    callback!(true, false);
  }
}
