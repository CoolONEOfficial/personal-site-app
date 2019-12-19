import 'package:flutter/material.dart';

class StringItem extends StatefulWidget {
  final String name;
  final String startValue;
  final Function(String) onChanged;

  final TextEditingController textController = TextEditingController();

  StringItem(this.name, this.onChanged, {this.startValue});

  @override
  _StringItemState createState() => _StringItemState(startValue);
}

class _StringItemState extends State<StringItem> {
  _StringItemState(value) {
    if (value is String) widget.textController.text = value;
  }

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      title: Text(widget.name),
      trailing: Container(
          width: 150,
          child: TextField(
            controller: widget.textController,
            onChanged: (str) {
              if (str.length > 0) widget.onChanged(str);
            },
          )),
    );
  }
}
