import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/main.dart';
import 'package:personal_site_app/screens/items/BoolItem.dart';
import 'package:personal_site_app/screens/items/DateItem.dart';
import 'package:personal_site_app/screens/items/LocalizedStringItem.dart';
import 'package:personal_site_app/screens/items/StringItem.dart';

class ScreenEditCreateArgs {}

enum EditCreateMode { EDIT, CREATE }

class ScreenEditCreate extends StatefulWidget {
  static const route = '/screens/edit_create';
  final Map<String, dynamic> data;
  final EditCreateMode mode;
  final DocumentSnapshot ssDoc;

  const ScreenEditCreate(this.mode, {this.data = const {}, this.ssDoc, Key key})
      : super(key: key);

  @override
  _ScreenEditCreateState createState() => _ScreenEditCreateState();
}

class _ScreenEditCreateState extends State<ScreenEditCreate> {
  ScreenEditCreateArgs get args => ModalRoute.of(context).settings.arguments;

  Map<String, dynamic> tempData = {};

  List<Widget> list;

  @override
  void initState() {
    list = [
      LocalizedStringItem(
        'title',
        (val) {
          tempData['title'] = val;
        },
        startValue: widget.data['title'] != null
            ? Map<String, dynamic>.from(widget.data['title'])
            : null,
      ),
      StringItem(
        'organisation',
        (val) {
          tempData['organisation'] = val;
        },
        startValue: widget.data['organisation'],
      ),
      BoolItem(
        'singleImage',
        (val) {
          tempData['singleImage'] = val;
        },
        startValue: widget.data['singleImage'],
      ),
      DateItem(
        'date',
        (val) {
          tempData['date'] = val;
        },
        startValue: widget.data['date'],
      )
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              debugPrint('result data: ' + tempData.toString());

              switch (widget.mode) {
                case EditCreateMode.EDIT:
                  await widget.ssDoc.reference.setData(tempData);

                  break;
                case EditCreateMode.CREATE:
                  await databaseReference
                      .collection("achievements")
                      .add(tempData);
                  break;
                default:
                  throw Exception('mode is not set!!');
              }

              Navigator.pop(context, true);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          return list[index];
        },
        itemCount: list.length,
      ),
    );
  }
}
