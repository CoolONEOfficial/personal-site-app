import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/TabList.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/screens/Control.dart';
import 'package:personal_site_app/screens/EditCreate.dart';

import '../Item.dart';
import '../main.dart';

final List<String> platformsEnumMap = [
  'web',
  'desktop',
  'mobile',
  'ios',
  'android',
  'windows',
  'linux',
  'macosx'
];

final List<String> projectsEnumMap = [
  'app',
  'game'
];

class Projects extends CallableWidget {
  static const ItemMap itemMap = const ItemMap({
    'type': ItemType.SELECT_PROJECT_TYPE,
    'platform': ItemType.SELECT_PLATFORMS,
    'title': ItemType.LOCALIZED_STRING,
    'date': ItemType.DATE,
    'description': ItemType.LOCALIZED_MARKDOWN_STRING,
    'logo': ItemType.IMAGE_SINGLE,
    'images': ItemType.IMAGES,
    'singleImage': ItemType.IMAGE_SINGLE,
    'organisation': ItemType.STRING,
    'tags': ItemType.TAGS,
  }, {
    'description': ItemType.LOCALIZED_MARKDOWN_STRING,
    'videos': ItemType.LIST_STRING,
    'github': ItemType.URL,
    'google_play': ItemType.URL,
    'app_store': ItemType.URL,
    'site': ItemType.URL
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
