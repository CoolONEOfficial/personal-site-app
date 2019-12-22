import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/TabList.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/screens/Control.dart';
import 'package:personal_site_app/screens/EditCreate.dart';

import '../Item.dart';
import '../main.dart';

enum EventType {
  OTHER,
  HACKATHON,
  MEETUP,
  CONFERENCE,
  WEBINAR,
  LECTURE,
  TRAINING,
  MASTER_CLASS,
  FORUM,
  TOURNAMENT,
  COMPETITION,
  EXHIBITION,
  FESTIVAL,
  ROUND_TABLE,
  STUDY,
  EXCURSION
}

final List<String> eventsEnumMap = [
  'Other',
  'Hack',
  'Meetup',
  'Conference',
  'Webinar',
  'Lecture',
  'Training',
  'Master class',
  'Forum',
  'Tournament',
  'Competition',
  'Exhibition',
  'Festival',
  'Round table',
  'Study',
  'Excursion',
];

class Events extends CallableWidget {
  static const ItemMap itemMap = const ItemMap({
    'type': ItemType.ENUM_EVENTS,
    'title': ItemType.LOCALIZED_STRING,
    'date': ItemType.DATE,
    'description': ItemType.LOCALIZED_MULTILINE_STRING,
    'logo': ItemType.IMAGE_SINGLE,
    'images': ItemType.IMAGES,
    'singleImage': ItemType.IMAGE_SINGLE,
    'organisation': ItemType.STRING,
  }, {
    'youtube': ItemType.STRING,
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
