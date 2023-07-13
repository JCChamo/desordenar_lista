import 'package:flutter/material.dart';

class ListViewItem extends StatefulWidget {
  ListViewItem(this.name, {Key? key}) : super(key: key);

  String? name;

  @override
  State<ListViewItem> createState() => _ListViewItemState();
}

class _ListViewItemState extends State<ListViewItem> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.8,
      child: Text(
        widget.name ?? '',
        style: TextStyle(fontSize: size.width * 0.05),
      ),
    );
  }
}
