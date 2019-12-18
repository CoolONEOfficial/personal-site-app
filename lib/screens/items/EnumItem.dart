import 'package:flutter/material.dart';

class EnumItem extends StatefulWidget {
  final String name;
  final List<String> enumMap;
  final int startValue;
  final Function(int) onChanged;

  EnumItem(this.name, this.onChanged, this.enumMap, {this.startValue});

  @override
  _EnumItemState createState() => _EnumItemState(startValue);
}

class _EnumItemState extends State<EnumItem> {
  _EnumItemState(value) {
    dropdownModel = value;
  }

  int dropdownModel;

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      title: Text(widget.name),
      trailing: Container(
        width: 120,
        child: DropdownButton<int>(
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
          items: widget.enumMap.asMap().entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
