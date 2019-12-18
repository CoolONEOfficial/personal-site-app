import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/screens/Control.dart';
import 'package:personal_site_app/screens/EditCreate.dart';

import '../Item.dart';
import '../main.dart';

class Achievements extends CallableWidget {
  static const Map<String, ItemType> listMap = {
    'title': ItemType.LOCALIZED_STRING,
    'date': ItemType.DATE,
    'organisation': ItemType.STRING,
    'logo': ItemType.IMAGE_SINGLE,
    'images': ItemType.IMAGES,
    'singleImage': ItemType.IMAGE_SINGLE
  };

  @override
  _AchievementsState createState() => _AchievementsState();

  @override
  onCreateClick(ctx) async {
    await Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) =>
            ScreenEditCreate.create(Achievements.listMap, 'achievements'),
      ),
    );
  }
}

class _AchievementsState extends State<Achievements> {
  @override
  Widget build(BuildContext ctx) {
    return buildFutureBuilder(
        databaseReference.collection('achievements').getDocuments(),
        (QuerySnapshot ss) {
      return ListView.builder(
        itemCount: ss.documents.length,
        itemBuilder: (context, index) {
          final mDoc = ss.documents[index];
          return Item(
            mDoc,
            Achievements.listMap,
            onEditClicked: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenEditCreate.edit(
                      Achievements.listMap, mDoc.data, mDoc),
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
