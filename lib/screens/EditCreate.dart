import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/main.dart';
import 'package:personal_site_app/screens/items/BoolItem.dart';
import 'package:personal_site_app/screens/items/DateItem.dart';
import 'package:personal_site_app/screens/items/EnumItem.dart';
import 'package:personal_site_app/screens/items/ImagesItem.dart';
import 'package:personal_site_app/screens/items/LocalizedStringItem.dart';
import 'package:personal_site_app/screens/items/ImageSingleItem.dart';
import 'package:personal_site_app/screens/items/StringItem.dart';
import 'package:personal_site_app/tabs/Events.dart';
import 'package:progress_dialog/progress_dialog.dart';

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
  IMAGE_SINGLE,
  IMAGE_LOGO,
  IMAGES,
  ENUM_EVENTS,
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
              debugPrint('write string "$val" on key "$mKey"');
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
        case ItemType.IMAGE_SINGLE:
          item = ImageSingleItem(mKey, (val) {
            tempData[mKey] = val;
          },
              startValue: widget.data[mKey],
              docPath:
                  widget.ssDoc != null ? widget.ssDoc.reference.path : null);
          break;
        case ItemType.IMAGE_LOGO:
          item = ImageSingleItem(mKey, (val) {
            tempData[mKey] = val;
          },
              startValue: widget.data[mKey],
              docPath:
              widget.ssDoc != null ? widget.ssDoc.reference.path : null);
          break;
        case ItemType.IMAGES:
          item = ImagesItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            startValue: widget.data[mKey],
            docPath: widget.ssDoc != null ? widget.ssDoc.reference.path : null,
          );
          break;
        case ItemType.ENUM_EVENTS:
          item = EnumItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            eventsEnumMap,
            startValue: widget.data[mKey],
          );
          break;
      }
      list.add(item);
    });

    super.initState();
  }

  final storage = storageReference;

  syncImages(DocumentReference refDoc) async {
//    debugPrint('start sync.. ssDoc: ${ssDoc.toString()}');

    for (var mEntry in widget.listMap.entries) {
      final mName = mEntry.key,
          mType = mEntry.value,
          mVal = tempData[mName],
          mOrigVal = widget.data[mName];

      if (mVal != null) {
        switch (mType) {
          case ItemType.IMAGE_SINGLE:
            if (widget.mode == EditCreateMode.EDIT && mOrigVal != null) {
              ImageSingleItem.deleteStorageSingleImage(refDoc.path, mName);
            }

            if (mVal is FileImage) {
              debugPrint('uploading image..');
              await storage
                  .child('${refDoc.path}/$mName/1.jpg')
                  .putFile(mVal.file)
                  .onComplete;
              debugPrint('upload complete!');
            }
            break;
          case ItemType.IMAGES:
            if (widget.mode == EditCreateMode.EDIT && mOrigVal != null) {
              await ImagesItem.deleteStorageImages(refDoc.path);
            }

            for (var mId = 0; mId < mVal.length; mId++) {
              final FileImage mImage = mVal[mId];
              debugPrint('uploading image..');
              await storage
                  .child('${refDoc.path}/images/${(mId + 1).toString()}.jpg')
                  .putFile(mImage.file)
                  .onComplete;
              debugPrint('upload complete! deleting cached image..');

              await mImage.file.delete();
              debugPrint('delete complete!');
            }
            break;
          default:
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.collName != null
            ? 'New item in ${widget.collName}'
            : widget.ssDoc.data.containsKey('title')
                ? widget.ssDoc.data['title']['en']
                : '...'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              final pr = new ProgressDialog(context);
              pr.show();

              var copyTempData = Map.from(tempData);
              for (var mEntry in widget.listMap.entries) {
                final mName = mEntry.key,
                    mType = mEntry.value,
                    mVal = tempData[mName];

                switch (mType) {
                  case ItemType.IMAGE_SINGLE:
                    if (mVal is ImageProvider) {
                      copyTempData[mName] = true;
                    }
                    break;
                  case ItemType.IMAGES:
                    if (mVal is List) {
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

                  await syncImages(widget.ssDoc.reference);

                  break;
                case EditCreateMode.CREATE:
                  debugPrint('create data: ' + copyTempData.toString());
                  final newSsDoc = await databaseReference
                      .collection(widget.collName)
                      .add(Map.from(copyTempData));

                  await syncImages(newSsDoc);

                  break;
                default:
                  throw Exception('mode is not set!!');
              }

              pr.hide();

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
