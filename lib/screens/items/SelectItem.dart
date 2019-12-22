import 'package:flutter/material.dart';

class SelectItem extends StatefulWidget {
  final String name;
  final List<String> selectMap;
  final String startValue;
  final Function(String) onChanged;

  SelectItem(this.name, this.onChanged, this.selectMap, {this.startValue});

  @override
  _SelectItemState createState() => _SelectItemState(startValue);
}

class _SelectItemState extends State<SelectItem> {
  _SelectItemState(value) {
    dropdownModel = value;
  }

  String dropdownModel;

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      title: Text(widget.name),
      trailing: Container(
        width: 120,
        child: DropdownButton<String>(
          value: dropdownModel,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          onChanged: (newValue) {
            widget.onChanged(newValue);
            setState(() {
              dropdownModel = newValue;
            });
          },
          items: widget.selectMap.map((entry) {
            return DropdownMenuItem<String>(
              value: entry,
              child: Text(entry),
            );
          }).toList(),
        ),
      ),
    );
  }
}
