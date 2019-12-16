import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/Achievements.dart';
import 'package:personal_site_app/main.dart';

class ScreenControlArgs {}

class ScreenControl extends StatefulWidget {
  static const route = '/screens/control';

  @override
  _ScreenControlState createState() => _ScreenControlState();
}

abstract class CallableWidget extends StatefulWidget {
  onCreateClick(BuildContext ctx);
}

class _ScreenControlState extends State<ScreenControl>
    with SingleTickerProviderStateMixin {
  ScreenControlArgs get args => ModalRoute.of(context).settings.arguments;

  TabController tabController;
  List<CallableWidget> tabData;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: tabs.length);
    tabData = [
      Achievements(),
      Achievements(),
      Achievements(),
      Achievements(),
    ];

    super.initState();
  }

  void createRecord() async {
//    await databaseReference.collection("testtest")
//        .document()
//        .setData({
//      'title': 'Mastering Flutter',
//      'description': 'Programming Guide for Dart'
//    }); its update

    DocumentReference ref = await databaseReference.collection("testtest").add({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
    print(ref.documentID);
  }

  static const tabs = [
    {'icon': Icons.star, 'name': 'achievements'},
    {'icon': Icons.today, 'name': 'events'},
    {'icon': Icons.code, 'name': 'achievements'},
    {'icon': Icons.book, 'name': 'achievements'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal site app'),
        bottom: TabBar(
          controller: tabController,
          tabs: tabs.map((i) => Tab(icon: Icon(i['icon']))).toList(),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: tabData,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tabData[tabController.index].onCreateClick(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
