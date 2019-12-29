import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/main.dart';
import 'package:personal_site_app/screens/items/BoolItem.dart';
import 'package:personal_site_app/screens/items/DateItem.dart';
import 'package:personal_site_app/screens/items/ListStringItem.dart';
import 'package:personal_site_app/screens/items/LocationItem.dart';
import 'package:personal_site_app/screens/items/SelectItem.dart';
import 'package:personal_site_app/screens/items/ImagesItem.dart';
import 'package:personal_site_app/screens/items/LocalizedStringItem.dart';
import 'package:personal_site_app/screens/items/ImageSingleItem.dart';
import 'package:personal_site_app/screens/items/StringItem.dart';
import 'package:personal_site_app/screens/items/TagsItem.dart';
import 'package:personal_site_app/tabs/Achievements.dart';
import 'package:personal_site_app/tabs/Events.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ScreenEditCreateArgs {}

enum EditCreateMode { EDIT, CREATE }

class ItemMap {
  final Map<String, ItemType> previewMap;
  final Map<String, ItemType> pageMap;

  const ItemMap(this.previewMap, this.pageMap);
}

class ItemData {
  final Map<String, dynamic> previewData;
  final Map<String, dynamic> pageData;

  const ItemData(this.previewData, this.pageData);

  static fromItemDoc(ItemDoc itemDoc) async =>
      ItemData(itemDoc.previewDoc.data, itemDoc.pageDoc.data);
}

class ItemDoc {
  final DocumentSnapshot previewDoc;
  final DocumentSnapshot pageDoc;

  const ItemDoc(this.previewDoc, this.pageDoc);

  static fromRootDoc(DocumentSnapshot rootDoc) async => ItemDoc(rootDoc,
      (await rootDoc.reference.collection('page').document('doc').get()));
}

class ScreenEditCreate extends StatefulWidget {
  static const route = '/screens/edit_create';
  final ItemData data;
  final EditCreateMode mode;
  final ItemDoc itemDoc;
  final CollectionReference rootCollRef;
  final ItemMap itemMap;

  const ScreenEditCreate.create(this.itemMap, this.rootCollRef,
      {this.mode = EditCreateMode.CREATE,
      this.itemDoc = const ItemDoc(null, null),
      this.data = const ItemData({}, {}),
      Key key})
      : super(key: key);

  const ScreenEditCreate.edit(this.itemMap, this.data, this.itemDoc,
      {this.mode = EditCreateMode.EDIT, this.rootCollRef, Key key})
      : super(key: key);

  @override
  _ScreenEditCreateState createState() => _ScreenEditCreateState();
}

enum ItemType {
  LOCALIZED_STRING,
  LOCALIZED_MULTILINE_STRING,
  STRING,
  LIST_STRING,
  BOOL,
  DATE,
  LOCATION,
  IMAGE_SINGLE,
  IMAGE_LOGO,
  IMAGES,
  SELECT_EVENTS,
  SELECT_ACHIEVEMENTS,
  TAGS
}

class _ScreenEditCreateState extends State<ScreenEditCreate> {
  ScreenEditCreateArgs get args => ModalRoute.of(context).settings.arguments;

  ItemData tempData = ItemData({}, {});

  List<Widget> list = [];

  @override
  void initState() {
    initList(widget.data, tempData, widget.itemDoc);

    super.initState();
  }

  initList(ItemData data, ItemData tempData, ItemDoc itemDoc) {
    _initList(widget.itemMap.previewMap, widget.data.previewData,
        tempData.previewData, itemDoc.previewDoc);
    list.add(Divider());
    _initList(widget.itemMap.pageMap, widget.data.pageData, tempData.pageData,
        itemDoc.pageDoc);
  }

  _initList(Map<String, dynamic> map, Map<String, dynamic> data,
      Map<String, dynamic> tempData, DocumentSnapshot ssDoc) {
    map.forEach((mKey, mVal) {
      var item;
      switch (mVal) {
        case ItemType.LOCALIZED_STRING:
          item = LocalizedStringItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            startValue: data[mKey] != null
                ? Map<String, dynamic>.from(data[mKey])
                : null,
          );
          break;
        case ItemType.LOCALIZED_MULTILINE_STRING:
          item = LocalizedStringItem(
            mKey,
            (val) {
              debugPrint('neval: $val');
              final writeVal = {
                'ru': (val['ru'] as String).replaceAll('\n', '\\n'),
                'en': (val['en'] as String).replaceAll('\n', '\\n')
              };
              debugPrint('wr val: $writeVal');
              tempData[mKey] = writeVal;
            },
            startValue: data != null && data[mKey] != null
                ? Map<String, dynamic>.from(data[mKey])
                : null,
            inputType: TextInputType.multiline,
          );
          break;
        case ItemType.STRING:
          item = StringItem(
            mKey,
            (val) {
              debugPrint('write string "$val" on key "$mKey"');
              tempData[mKey] = val;
            },
            startValue: data != null ? data[mKey] : null,
          );
          break;
        case ItemType.LIST_STRING:
          item = ListStringItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            startValue: List<String>.from(data[mKey]),
          );
          break;
        case ItemType.BOOL:
          item = BoolItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            startValue: data[mKey],
          );
          break;
        case ItemType.DATE:
          item = DateItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            startValue: data[mKey]?.toDate(),
          );
          break;
        case ItemType.LOCATION:
          item = LocationItem(
            mKey,
            (val) {
              debugPrint('new location: $val');
              tempData[mKey] = val;
            },
            startValue: data[mKey] != null
                ? Map<String, dynamic>.from(data[mKey])
                : null,
          );
          break;
        case ItemType.IMAGE_SINGLE:
          item = ImageSingleItem(mKey, (val) {
            tempData[mKey] = val;
          }, startValue: data[mKey], docPath: ssDoc?.reference?.path);
          break;
        case ItemType.IMAGE_LOGO:
          item = ImageSingleItem(mKey, (val) {
            tempData[mKey] = val;
          }, startValue: data[mKey], docPath: ssDoc?.reference?.path);
          break;
        case ItemType.IMAGES:
          item = ImagesItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            startValue: data[mKey],
            docPath: ssDoc?.reference?.path,
          );
          break;
        case ItemType.SELECT_EVENTS:
          item = SelectItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            eventsEnumMap,
            startValue: data[mKey],
          );
          break;
        case ItemType.SELECT_ACHIEVEMENTS:
          item = SelectItem(
            mKey,
            (val) {
              tempData[mKey] = val;
            },
            achievementsEnumMap,
            startValue: data[mKey],
          );
          break;
        case ItemType.TAGS:
          item = TagsItem(mKey, (val) {
            tempData[mKey] = val;
          },
              startValue:
                  data[mKey] != null ? List<String>.from(data[mKey]) : []);
          break;
      }
      list.add(item);
    });
  }

  _syncImages(
    Map<String, ItemType> itemMapData,
    Map<String, dynamic> tempItemData,
    Map<String, dynamic> itemData,
    DocumentReference refDoc,
  ) async {
    for (var mEntry in itemMapData.entries) {
      final mName = mEntry.key,
          mType = mEntry.value,
          mVal = tempItemData[mName],
          mOrigVal = itemData[mName];

      if (mVal != null) {
        switch (mType) {
          case ItemType.IMAGE_SINGLE:
            if (widget.mode == EditCreateMode.EDIT && mOrigVal != null) {
              ImageSingleItem.deleteStorageSingleImage(refDoc.path, mName);
            }

            if (mVal is FileImage) {
              debugPrint('uploading image..');
              await storageReference
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
              await storageReference
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

  uploadItemData() async {
    final DocumentReference refDoc = await _uploadItemData(
      widget.itemMap.previewMap,
      tempData.previewData,
      widget.data.previewData,
      widget.itemDoc.previewDoc?.reference,
      widget.rootCollRef,
    );
    await _uploadItemData(
      widget.itemMap.pageMap,
      tempData.pageData,
      widget.data.pageData,
      widget.itemDoc.pageDoc?.reference,
      refDoc.collection('page'),
      createDocName: 'doc',
    );

    await _syncImages(
      widget.itemMap.previewMap,
      tempData.previewData,
      widget.data.previewData,
      refDoc,
    );
    await _syncImages(
      widget.itemMap.pageMap,
      tempData.pageData,
      widget.data.pageData,
      refDoc,
    );
  }

  Future<DocumentReference> _uploadItemData(
    Map<String, ItemType> itemMapData,
    Map<String, dynamic> tempItemData,
    Map<String, dynamic> itemData,
    DocumentReference docRef,
    CollectionReference collRef, {
    String createDocName,
  }) async {
    var copyTempData = Map.from(tempItemData);
    for (var mEntry in itemMapData.entries) {
      final mName = mEntry.key,
          mType = mEntry.value,
          mVal = tempItemData[mName];

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
        await docRef.setData(Map.from(copyTempData), merge: true);

        return docRef;

        break;
      case EditCreateMode.CREATE:
        debugPrint('create data: ' + copyTempData.toString());
        final Map<String, dynamic> createData = Map.from(copyTempData);
        if (createDocName != null) {
          await collRef.document(createDocName).setData(createData);
          return collRef.document(createDocName);
        } else {
          return await collRef.add(createData);
        }

        break;
      default:
        throw Exception('mode is not set!!');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.rootCollRef != null
            ? 'New item in ${widget.rootCollRef.path}'
            : widget.itemDoc.previewDoc.data.containsKey('title')
                ? widget.itemDoc.previewDoc.data['title']['en']
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

              await uploadItemData();
              await Future.delayed(const Duration(seconds: 2));

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
