import 'package:flutter/material.dart';

class StringItem extends StatefulWidget {
  final String name;
  final String startValue;
  final Function(String) onChanged;
  final TextInputType keyboardType;

  StringItem(this.name, this.onChanged, {this.startValue, this.keyboardType});

  @override
  _StringItemState createState() => _StringItemState(startValue);
}

class _StringItemState extends State<StringItem> {
  _StringItemState(value) {
    if (value is String) this.textController.text = value;
  }

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      title: Text(widget.name),
      trailing: Container(
          width: 150,
          child: TextField(
            controller: this.textController,
            keyboardType: widget.keyboardType,
            onChanged: (str) {
              if (str.length > 0) widget.onChanged(str);
            },
          )),
    );
  }
}
