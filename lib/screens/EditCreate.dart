import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_site_app/main.dart';
import 'package:personal_site_app/screens/items/BoolItem.dart';
import 'package:personal_site_app/screens/items/DateItem.dart';
import 'package:personal_site_app/screens/items/LocalizedStringItem.dart';
import 'package:personal_site_app/screens/items/SingleImageItem.dart';
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

enum ItemType { LOCALIZED_STRING, STRING, BOOL, DATE, SINGLE_IMAGE }

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
            startValue:
                widget.data[mKey] != null ? widget.data[mKey].toDate() : null,
          );
          break;
        case ItemType.SINGLE_IMAGE:
          item = SingleImageItem(mKey, (val) {
            tempData[mKey] = val;
          },
              startValue: widget.data[mKey],
              docPath:
                  widget.ssDoc != null ? widget.ssDoc.reference.path : null);
          break;
      }
      list.add(item);
    });

    super.initState();
  }

  final storage = FirebaseStorage.instance.ref();

  deleteImages(DocumentReference refDoc) {
    final imgStr = '${refDoc.path}/singleImage/';
    debugPrint('deleting old singleimage.. $imgStr');
    return Future.wait([
      storage.child('${imgStr}1.jpg').delete(),
      storage.child('${imgStr}1_400x400.jpg').delete()
    ]);
  }

  syncImages(DocumentReference refDoc) async {
//    debugPrint('start sync.. ssDoc: ${ssDoc.toString()}');

    for (var mEntry in widget.listMap.entries) {
      final mName = mEntry.key,
          mType = mEntry.value,
          mVal = tempData[mName],
          mOrigVal = widget.data[mName];

      switch (mType) {
        case ItemType.SINGLE_IMAGE:
          if (widget.mode == EditCreateMode.EDIT && mOrigVal != null) {
            await deleteImages(refDoc);
          }

          if (mVal is FileImage) {
            debugPrint('uploading image..');
            await storage
                .child('${refDoc.path}/singleImage/1.jpg')
                .putFile(mVal.file)
                .onComplete;
            debugPrint('upload complete!');
          }
          break;
        default:
          break;
      }
    }
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
              var copyTempData = Map.from(tempData);
              for (var mEntry in widget.listMap.entries) {
                final mName = mEntry.key,
                    mType = mEntry.value,
                    mVal = tempData[mName];

                switch (mType) {
                  case ItemType.SINGLE_IMAGE:
                    if (mVal is ImageProvider) {
                      copyTempData[mName] = true;
                    }
                    break;
                  default:
                    break;
                }
              }

              switch (widget.mode) {
                case EditCreateMode.EDIT:
                  debugPrint('edit data: ' + copyTempData.toString());
                  await widget.ssDoc.reference
                      .setData(Map.from(copyTempData), merge: true);

                  syncImages(widget.ssDoc.reference);

                  break;
                case EditCreateMode.CREATE:
                  debugPrint('create data: ' + copyTempData.toString());
                  final newSsDoc = await databaseReference
                      .collection(widget.collName)
                      .add(Map.from(copyTempData));

                  syncImages(newSsDoc);

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
