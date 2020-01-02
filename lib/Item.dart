import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/main.dart';
import 'package:personal_site_app/screens/EditCreate.dart';
import 'package:personal_site_app/screens/items/ImagesItem.dart';
import 'package:personal_site_app/screens/items/ImageSingleItem.dart';

class Item extends StatefulWidget {
  final ItemDoc itemDoc;
  final Function() onEditClicked;
  final Function() onDeleted;
  final ItemMap itemMap;

  const Item(
    this.itemDoc,
    this.itemMap, {
    Key key,
    this.onEditClicked,
    this.onDeleted,
  }) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  deleteItem() async {
    debugPrint(
        'deleting: ${widget.itemDoc.previewDoc.reference.path} and page doc..');

    await Future.wait(List.from([
      _deleteItem(widget.itemMap.previewMap, widget.itemDoc.previewDoc.data),
      _deleteItem(widget.itemMap.pageMap, widget.itemDoc.pageDoc.data),
    ]));

    await Future.wait(List.from([
      widget.itemDoc.previewDoc.reference.delete(),
      widget.itemDoc.pageDoc.reference.delete(),
    ]));

    widget.onDeleted();
  }

  _deleteItem(Map itemMap, Map itemData) async {
    final docRef = widget.itemDoc.previewDoc.reference;
    for (String mName
        in itemMap.keys.where((mKey) => itemMap[mKey] == ItemType.IMAGES)) {
      await ImagesItem.deleteStorageImages(getDocPath(docRef), mName);
    }

    for (final mEntry in itemMap.entries
        .where((mEntry) => mEntry.value == ItemType.IMAGE_SINGLE)) {
      await ImageSingleItem.deleteStorageSingleImage(
          getDocPath(docRef), mEntry.key, itemData[mEntry.key]);
    }
  }

  @override
  Widget build(BuildContext ctx) {
    final data = widget.itemDoc.previewDoc.data;
    var imageFolder;
    var ext;
    if (data.containsKey('logo')) {
      imageFolder = 'logo/1';
      ext = data['logo'];
    } else if (data.containsKey('images')) {
      imageFolder = 'images/1';
      ext = '.jpg';
    } else if (data.containsKey('singleImage')) {
      imageFolder = 'singleImage/1';
      ext = data['singleImage'];
    }

    final docSs = widget.itemDoc.previewDoc;
    final docPath = docSs.reference.path;
    final imgPath =
        '${docPath.substring(0, docPath.indexOf('/'))}/${docSs.documentID}/${imageFolder}_400x400$ext';

    debugPrint('imgpath: $imgPath');

    return ListTile(
      leading: imageFolder != null
          ? buildFutureBuilder(
              storageReference.child(imgPath).getDownloadURL(),
              (url) => Image.network(url),
              fixedWidth: 100,
            )
          : null,
      title: Text(
          data.containsKey('title') ? data['title']['en'].toString() : '...'),
      subtitle: Text(data.containsKey('date')
          ? (data['date'] as Timestamp).toDate().toIso8601String()
          : '...'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: widget.onEditClicked,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return buildDialogDelete(ctx, onDelete: deleteItem);
                  });
            },
          ),
        ],
      ),
    );
  }
}

getDocPath(DocumentReference ref) => ref != null
    ? '${ref.path?.substring(0, ref.path?.indexOf('/'))}/${ref.documentID}'
    : null;
