import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/tabs/Achievements.dart';
import 'package:personal_site_app/main.dart';
import 'package:personal_site_app/tabs/Books.dart';
import 'package:personal_site_app/tabs/Events.dart';
import 'package:personal_site_app/tabs/Projects.dart';

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
      Events(),
      Projects(),
      Books(),
    ];

    super.initState();
  }

  static const tabs = [
    {'icon': Icons.star, 'name': 'achievements'},
    {'icon': Icons.today, 'name': 'events'},
    {'icon': Icons.code, 'name': 'projects'},
    {'icon': Icons.book, 'name': 'books'},
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
