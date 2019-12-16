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
  final String collName;
  final Map<String, ItemType> listMap;

  const ScreenEditCreate.create(this.listMap, this.collName,
      {this.mode = EditCreateMode.CREATE,
      this.ssDoc,
      this.data = const {},
      Key key})
      : super(key: key);

  const ScreenEditCreate.edit(this.listMap, this.data, this.ssDoc,
      {this.mode = EditCreateMode.EDIT, this.collName, Key key})
      : super(key: key);

  @override
  _ScreenEditCreateState createState() => _ScreenEditCreateState();
}

enum ItemType {
  LOCALIZED_STRING,
  STRING,
  BOOL,
  DATE,
}

class _ScreenEditCreateState extends State<ScreenEditCreate> {
  ScreenEditCreateArgs get args => ModalRoute.of(context).settings.arguments;

  Map<String, dynamic> tempData = {};

  List<Widget> list;

  @override
  void initState() {
    list = [];

    widget.listMap.forEach((mKey, mVal) {
      var item;
      switch (mVal) {
        case ItemType.LOCALIZED_STRING:
          item = LocalizedStringItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            startValue: widget.data[mKey] != null
                ? Map<String, dynamic>.from(widget.data[mKey])
                : null,
          );
          break;
        case ItemType.STRING:
          item = StringItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            startValue: widget.data[mKey],
          );
          break;
        case ItemType.BOOL:
          item = BoolItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            startValue: widget.data[mKey],
          );
          break;
        case ItemType.DATE:
          item = DateItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            startValue: widget.data[mKey],
          );
          break;
      }
      list.add(item);
    });

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
                      .collection(widget.collName)
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
