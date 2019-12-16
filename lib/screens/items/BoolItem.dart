import 'package:flutter/material.dart';

class BoolItem extends StatefulWidget {
  final String name;
  final bool startValue;
  final Function(bool) onChanged;

  BoolItem(this.name, this.onChanged, {this.startValue});

  @override
  _BoolItemState createState() => _BoolItemState(startValue ?? false);
}

class _BoolItemState extends State<BoolItem> {
  _BoolItemState(value) {
    switchModel = value;
  }

  bool switchModel;

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      title: Text(widget.name),
      trailing: Switch(value: switchModel, onChanged: widget.onChanged),
    );
  }
}
