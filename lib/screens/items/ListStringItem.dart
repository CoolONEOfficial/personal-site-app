import 'package:flutter/material.dart';

class ListStringItem extends StatefulWidget {
  final String name;
  final List<String> startValue;
  final Function(List<String>) onChanged;

  final TextEditingController textController = TextEditingController();

  ListStringItem(this.name, this.onChanged, {this.startValue});

  @override
  _ListStringItemState createState() => _ListStringItemState(startValue);
}

class _ListStringItemState extends State<ListStringItem> {
  _ListStringItemState(value) {
    if (value is List<String>) listStr = value;
  }

  List<String> listStr = [];

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      title: Text(widget.name),
      subtitle: listStr.isNotEmpty ? Text(listStr.toString()) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              listStr.clear();
              widget.onChanged(listStr);
              setState(() {});
            },
          ),
          Container(
            width: 150,
            child: TextField(
              controller: widget.textController,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              listStr.add(widget.textController.text);
              widget.onChanged(listStr);
              widget.textController.text = '';
              setState(() {});
            },
          )
        ],
      ),
    );
  }
}
