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

    final List<Future> deleteFutures = [
      widget.itemDoc.previewDoc.reference.delete(),
      widget.itemDoc.pageDoc.reference.delete(),
      _deleteItem(widget.itemMap.previewMap),
      _deleteItem(widget.itemMap.pageMap),
    ];

    await Future.wait(deleteFutures);

    widget.onDeleted();
  }

  _deleteItem(Map itemMap) async {
    if (itemMap.containsValue(ItemType.IMAGES))
      await ImagesItem.deleteStorageImages(
          widget.itemDoc.previewDoc.reference.path);

    final singleImagesNames =
        itemMap.keys.where((mKey) => itemMap[mKey] == ItemType.IMAGE_SINGLE);
    for (String mName in singleImagesNames) {
      await ImageSingleItem.deleteStorageSingleImage(
          widget.itemDoc.previewDoc.reference.path, mName);
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      leading: widget.itemDoc.previewDoc.data.containsKey('singleImage') ||
              widget.itemDoc.previewDoc.data.containsKey('images')
          ? buildFutureBuilder(
              storageReference
                  .child(
                    '${widget.itemDoc.previewDoc.reference.path}/${widget.itemDoc.previewDoc.data.containsKey(
                      'singleImage',
                    ) ? 'singleImage' : 'images'}/1_400x400.jpg',
                  )
                  .getDownloadURL(),
              (url) => Image.network(url),
              fixedWidth: 100,
            )
          : null,
      title: Text(widget.itemDoc.previewDoc.data.containsKey('title')
          ? widget.itemDoc.previewDoc.data['title']['en'].toString()
          : '...'),
      subtitle: Text(widget.itemDoc.previewDoc.data.containsKey('date')
          ? (widget.itemDoc.previewDoc.data['date'] as Timestamp)
              .toDate()
              .toIso8601String()
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
