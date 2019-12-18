import 'package:flutter/material.dart';

class StringItem extends StatefulWidget {
  final String name;
  final String startValue;
  final Function(String) onChanged;

  StringItem(this.name, this.onChanged, {this.startValue});

  @override
  _StringItemState createState() => _StringItemState(startValue ?? "");
}

class _StringItemState extends State<StringItem> {
  _StringItemState(value) {
    textController.text = value;
  }

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      title: Text(widget.name),
      trailing: Container(
          width: 150,
          child: TextField(
            controller: textController,
            onChanged: widget.onChanged,
          )),
    );
  }
}
