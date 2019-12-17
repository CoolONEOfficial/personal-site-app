import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/screens/Control.dart';
import 'package:personal_site_app/screens/EditCreate.dart';

import '../Item.dart';
import '../main.dart';

class Events extends CallableWidget {
  static const Map<String, ItemType> listMap = {
    'title': ItemType.LOCALIZED_STRING,
    'date': ItemType.DATE,
    'organisation': ItemType.STRING,
    'images': ItemType.IMAGES,
    'singleImage': ItemType.SINGLE_IMAGE
  };

  @override
  _EventsState createState() => _EventsState();

  @override
  onCreateClick(ctx) async {
    await Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => ScreenEditCreate.create(Events.listMap, 'events'),
      ),
    );
  }
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext ctx) {
    return buildFutureBuilder(
        databaseReference.collection('events').getDocuments(),
        (QuerySnapshot ss) {
      return ListView.builder(
        itemCount: ss.documents.length,
        itemBuilder: (context, index) {
          final mDoc = ss.documents[index];
          return Item(
            mDoc,
            onEditClicked: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ScreenEditCreate.edit(Events.listMap, mDoc.data, mDoc),
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
