import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/TabList.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/screens/Control.dart';
import 'package:personal_site_app/screens/EditCreate.dart';

import '../Item.dart';
import '../main.dart';

class Projects extends CallableWidget {
  static const ItemMap itemMap = const ItemMap({
    'title': ItemType.LOCALIZED_STRING,
    'date': ItemType.DATE,
    'logo': ItemType.IMAGE_SINGLE,
    'images': ItemType.IMAGES,
    'singleImage': ItemType.IMAGE_SINGLE,
    'organisation': ItemType.STRING,
  }, {
    'youtube': ItemType.STRING,
    'github': ItemType.STRING,
    'site': ItemType.STRING
  });

  @override
  _ProjectsState createState() => _ProjectsState();

  @override
  onCreateClick(ctx) async {
    await Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => ScreenEditCreate.create(
            Projects.itemMap, databaseReference.collection('projects')),
      ),
    );
  }
}

class _ProjectsState extends State<Projects> {
  @override
  Widget build(BuildContext ctx) => TabList('projects', Projects.itemMap);
}
