import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/screens/Control.dart';
import 'package:personal_site_app/screens/EditCreate.dart';

import '../Item.dart';
import '../main.dart';

class Books extends CallableWidget {
  static const Map<String, ItemType> listMap = {
    'title': ItemType.LOCALIZED_STRING,
    'date': ItemType.DATE,
    'organisation': ItemType.STRING,
    'images': ItemType.IMAGES,
    'singleImage': ItemType.IMAGE_SINGLE
  };

  @override
  _BooksState createState() => _BooksState();

  @override
  onCreateClick(ctx) async {
    await Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) =>
            ScreenEditCreate.create(Books.listMap, 'books'),
      ),
    );
  }
}

class _BooksState extends State<Books> {
  @override
  Widget build(BuildContext ctx) {
    return buildFutureBuilder(
        databaseReference.collection('books').getDocuments(),
        (QuerySnapshot ss) {
      return ListView.builder(
        itemCount: ss.documents.length,
        itemBuilder: (context, index) {
          final mDoc = ss.documents[index];
          return Item(
            mDoc,
            Books.listMap,
            onEditClicked: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenEditCreate.edit(
                      Books.listMap, mDoc.data, mDoc),
                ),
              );
              setState(() {});
            },
            onDeleted: () {
              setState(() {});
            },
          );
        },
      );
    });
  }
}
