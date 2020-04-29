import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/screens/Auth.dart';
import 'package:personal_site_app/screens/Control.dart';
import 'package:personal_site_app/screens/Zefyr.dart';

final databaseReference = Firestore.instance;
final storageReference = FirebaseStorage.instance.ref();

void main() {
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
        brightness: Brightness.light,
        primaryColor: Colors.red,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark
      ),
      onGenerateRoute: (RouteSettings settings) {
        print('build route for ${settings.name}');
        var routes = <String, WidgetBuilder>{
          ScreenControl.route: (ctx) => ScreenControl(),
          ScreenAuth.route: (ctx) => ScreenAuth(),
          ScreenZefyr.route: (ctx) => ScreenZefyr(settings.arguments)
        };
        WidgetBuilder builder = routes[settings.name];
        return MaterialPageRoute(builder: (ctx) => builder(ctx));
      },
      initialRoute: ScreenAuth.route,
//      routes: {
//        ScreenControl.route: (ctx) => ScreenControl(),
//        ScreenAuth.route: (ctx) => ScreenAuth(),
//        ScreenZefyr.route: (ctx) => ScreenZefyr()
//      },
    );
  }
}
