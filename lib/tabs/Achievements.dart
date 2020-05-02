import 'package:flutter/material.dart';
import 'package:personal_site_app/TabList.dart';
import 'package:personal_site_app/screens/Control.dart';
import 'package:personal_site_app/screens/EditCreate.dart';

import '../main.dart';

final List<String> achievementsEnumMap = [
  'certificate',
  'diploma',
];

class Achievements extends CallableWidget {
  static const ItemMap itemMap = const ItemMap({
    'type': ItemType.SELECT_ACHIEVEMENTS,
    'urlName': ItemType.STRING,
    'title': ItemType.LOCALIZED_STRING,
    'date': ItemType.DATE,
    'description': ItemType.LOCALIZED_MARKDOWN_STRING,
    'singleImage': ItemType.IMAGE_SINGLE,
    'images': ItemType.IMAGES,
    'logo': ItemType.IMAGE_SINGLE,
    'organisation': ItemType.STRING,
    'tags': ItemType.TAGS,
  }, {
    'description': ItemType.LOCALIZED_MARKDOWN_STRING,
    'videos': ItemType.LIST_STRING,
    'site': ItemType.URL
  });

  @override
  _AchievementsState createState() => _AchievementsState();

  @override
  onCreateClick(ctx) async {
    await Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => ScreenEditCreate.create(
            Achievements.itemMap,
            'achievements'
        ),
      ),
    );
  }
}

class _AchievementsState extends State<Achievements> {
  @override
  Widget build(BuildContext ctx) =>
      TabList('achievements', Achievements.itemMap);
}
