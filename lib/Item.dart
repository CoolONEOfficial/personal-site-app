import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/components.dart';

class Item extends StatefulWidget {
  final DocumentSnapshot ssDoc;
  final Function() onEditClicked;
  final Function() onDeleted;

  const Item(
    this.ssDoc, {
    Key key,
    this.onEditClicked,
    this.onDeleted,
  }) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      title: Text(widget.ssDoc.data.containsKey('title')
          ? widget.ssDoc.data['title']['en'].toString()
          : '...'),
      subtitle: Text(widget.ssDoc.data.containsKey('date')
          ? (widget.ssDoc.data['date'] as Timestamp).toDate().toIso8601String()
          : '...'),
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
                    return buildDialogDelete(ctx, onDelete: () async {
                      debugPrint('deleting: ${widget.ssDoc.reference.path}');
                      Future.wait([
                        widget.ssDoc.reference.delete(),
                        FirebaseStorage.instance
                            .ref()
                            .child(
                                '/${widget.ssDoc.reference.path}/singleImage/1.jpg')
                            .delete(),
                        FirebaseStorage.instance
                            .ref()
                            .child(
                                '/${widget.ssDoc.reference.path}/singleImage/1_400x400.jpg')
                            .delete()
                      ]);

                      widget.onDeleted();
                    });
                  });
            },
          ),
        ],
      ),
    );
  }
}
