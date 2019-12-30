import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/TabList.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/screens/Control.dart';
import 'package:personal_site_app/screens/EditCreate.dart';

import '../Item.dart';
import '../main.dart';

final List<String> eventsEnumMap = [
  'other',
  'hack',
  'meetup',
  'conference',
  'webinar',
  'lecture',
  'training',
  'master_class',
  'forum',
  'tournament',
  'competition',
  'exhibition',
  'festival',
  'round_table',
  'study',
  'excursion',
];

class Events extends CallableWidget {
  static const ItemMap itemMap = const ItemMap({
    'type': ItemType.SELECT_EVENTS,
    'title': ItemType.LOCALIZED_STRING,
    'date': ItemType.DATE,
    'description': ItemType.LOCALIZED_MULTILINE_STRING,
    'logo': ItemType.IMAGE_SINGLE,
    'images': ItemType.IMAGES,
    'singleImage': ItemType.IMAGE_SINGLE,
    'organisation': ItemType.STRING,
    'location': ItemType.LOCATION,
    'tags': ItemType.TAGS,
    'place': ItemType.NUMBER
  }, {
    'description': ItemType.LOCALIZED_MULTILINE_STRING,
    'videos': ItemType.LIST_STRING,
    'site': ItemType.STRING
  });

  @override
  _EventsState createState() => _EventsState();

  @override
  onCreateClick(ctx) async {
    await Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => ScreenEditCreate.create(
            Events.itemMap, databaseReference.collection('events')),
      ),
    );
  }
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext ctx) =>
      TabList('events', Events.itemMap);
}
