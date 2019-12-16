import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/Achievements.dart';
import 'package:personal_site_app/screens/Control.dart';

final databaseReference = Firestore.instance;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal site app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: ScreenControl.route,
      routes: {
        ScreenControl.route: (ctx) => ScreenControl()
      },
    );
  }
}
