import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/screens/Auth.dart';
import 'package:personal_site_app/screens/Control.dart';

final databaseReference = Firestore.instance;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal site app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: ScreenAuth.route,
      routes: {
        ScreenControl.route: (ctx) => ScreenControl(),
        ScreenAuth.route: (ctx) => ScreenAuth()
      },
    );
  }
}
