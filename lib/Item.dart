import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/components.dart';

class Item extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function() onEditClicked;
  final Function() onDeleteClicked;

  const Item(
    this.data, {
    Key key,
    this.onEditClicked,
    this.onDeleteClicked,
  }) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      title: Text(widget.data['title']['en'].toString()),
      subtitle:
          Text((widget.data['date'] as Timestamp).toDate().toIso8601String()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: widget.onEditClicked,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return buildDialogDelete(ctx, onDelete: () {
                      // TODO: delete
                    });
                  });
            },
          ),
        ],
      ),
    );
  }
}
