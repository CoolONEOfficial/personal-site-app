import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/screens/Auth.dart';
import 'package:personal_site_app/screens/Control.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

final databaseReference = Firestore.instance;
final storageReference = FirebaseStorage.instance.ref();

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

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
