import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/main.dart';
import 'package:personal_site_app/screens/EditCreate.dart';
import 'package:personal_site_app/screens/items/ImagesItem.dart';
import 'package:personal_site_app/screens/items/ImageSingleItem.dart';

class Item extends StatefulWidget {
  final DocumentSnapshot ssDoc;
  final Function() onEditClicked;
  final Function() onDeleted;
  final Map<String, ItemType> listMap;

  const Item(
    this.ssDoc,
    this.listMap, {
    Key key,
    this.onEditClicked,
    this.onDeleted,
  }) : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      leading: widget.ssDoc.data.containsKey('singleImage') ||
              widget.ssDoc.data.containsKey('images')
          ? buildFutureBuilder(
              storageReference
                  .child(
                    '${widget.ssDoc.reference.path}/${widget.ssDoc.data.containsKey(
                      'singleImage',
                    ) ? 'singleImage' : 'images'}/1_400x400.jpg',
                  )
                  .getDownloadURL(),
              (url) => Image.network(url),
              fixedWidth: 100,
            )
          : null,
      title: Text(widget.ssDoc.data.containsKey('title')
          ? widget.ssDoc.data['title']['en'].toString()
          : '...'),
      subtitle: Text(widget.ssDoc.data.containsKey('date')
          ? (widget.ssDoc.data['date'] as Timestamp).toDate().toIso8601String()
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
                    return buildDialogDelete(ctx, onDelete: () async {
                      debugPrint('deleting: ${widget.ssDoc.reference.path}');

                      final List<Future> deleteFutures = [
                        widget.ssDoc.reference.delete()
                      ];

                      if (widget.listMap.containsValue(ItemType.IMAGES))
                        deleteFutures.add(ImagesItem.deleteStorageImages(
                            widget.ssDoc.reference.path));

                      final singleImagesNames = widget.listMap.keys.where(
                          (mKey) =>
                              widget.listMap[mKey] == ItemType.IMAGE_SINGLE);
                      for (String mName in singleImagesNames) {
                        deleteFutures.add(
                            ImageSingleItem.deleteStorageSingleImage(
                                widget.ssDoc.reference.path, mName));
                      }

                      await Future.wait(deleteFutures);

                      widget.onDeleted();
                    });
                  });
            },
          ),
        ],
      ),
    );
  }
}
