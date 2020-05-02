import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/TabList.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/screens/Control.dart';
import 'package:personal_site_app/screens/EditCreate.dart';

import '../Item.dart';
import '../main.dart';

class Books extends CallableWidget {
  static const ItemMap itemMap = const ItemMap({
    'title': ItemType.LOCALIZED_STRING,
    'urlName': ItemType.STRING,
    'date': ItemType.DATE,
    'description': ItemType.LOCALIZED_MARKDOWN_STRING,
    'singleImage': ItemType.IMAGE_SINGLE,
    'organisation': ItemType.STRING,
    'author': ItemType.STRING,
    'tags': ItemType.TAGS,
  }, {
    'description': ItemType.LOCALIZED_MARKDOWN_STRING,
    'videos': ItemType.LIST_STRING,
    'site': ItemType.URL
  });

  @override
  _BooksState createState() => _BooksState();

  @override
  onCreateClick(ctx) async {
    await Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (context) => ScreenEditCreate.create(
          Books.itemMap,
          'books',
        )
      ),
    );
  }
}

class _BooksState extends State<Books> {
  @override
  Widget build(BuildContext ctx) =>
      TabList('books', Books.itemMap);
}
