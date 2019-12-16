import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DateItem extends StatefulWidget {
  final String name;
  final DateTime startValue;
  final Function(Timestamp) onChanged;

  DateItem(this.name, this.onChanged, {this.startValue});

  @override
  _DateItemState createState() => _DateItemState(startValue);
}

class _DateItemState extends State<DateItem> {
  _DateItemState(value) {
    dateModel = value;
  }

  DateTime dateModel;

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      title: Text(widget.name),
      subtitle:
          dateModel != null ? Text(dateModel.toIso8601String()) : Container(),
      trailing: dateModel != null
          ? IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                dateModel = null;
                setState(() {});
                widget.onChanged(Timestamp.fromDate(dateModel));
              },
            )
          : IconButton(
              icon: Icon(Icons.today),
              onPressed: () async {
                dateModel = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2002),
                  lastDate: DateTime(2030),
                );
                setState(() {});

                widget.onChanged(Timestamp.fromDate(dateModel));
              },
            ),
    );
  }
}
