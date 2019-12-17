import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_site_app/components.dart';

class ImagesItem extends StatefulWidget {
  final String name;
  final String docPath;
  final bool startValue;
  final Function(List<ImageProvider>) onChanged;

  ImagesItem(this.name, this.onChanged, {this.startValue, this.docPath});

  @override
  _ImagesItemState createState() => _ImagesItemState();
}

class _ImagesItemState extends State<ImagesItem> {
  List<ImageProvider> imagesList = [];
  bool changed = false;
  bool localSelected = false;

  pickImages() async {
    final assetList = await MultiImagePicker.pickImages(maxImages: 8);
    for (var mAssetId = 0; mAssetId < assetList.length; mAssetId++) {
      final mAsset = assetList[mAssetId];
      final File f = await File(
              '${await getApplicationDocumentsDirectory()}/${widget.docPath}/$mAssetId.jpg')
          .create();
      await f.writeAsBytes((await mAsset.getByteData(quality: 80))
          .buffer
          .asUint8List()
          .toList());
      imagesList.add(FileImage(f));
    }
    changed = true;
    localSelected = true;
    setState(() {});
    widget.onChanged(imagesList);
  }

  deleteImage() {
    changed = true;
    imagesList = [];
    localSelected = false;
    setState(() {});
    widget.onChanged(null);
  }

  Widget buildTrailing() => imagesList.isEmpty
      ? IconButton(
          icon: Icon(Icons.image),
          onPressed: pickImages,
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: imagesList
              .map<Widget>((mImage) => Image(
                    image: mImage,
                  ))
              .toList()
              .sublist(0, imagesList.length > 3 ? 3 : imagesList.length - 1)
                ..add(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: deleteImage,
                )),
        );

  loadImages() async {
    var imageId = 1;
    do {
      try {
        final imgPath = '${widget.docPath}/images/$imageId.jpg';
        debugPrint('mPath: $imgPath');
        imagesList.add(
          NetworkImage(
            await FirebaseStorage.instance
                .ref()
                .child(imgPath)
                .getDownloadURL(),
          ),
        );
      } catch (e) {
        debugPrint('end images');
        return;
      }
      imageId++;
      debugPrint('next image id $imageId');
    } while (true);
  }

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
        title: Text(widget.name),
        trailing: Container(
          alignment: Alignment.centerRight,
          width: 200,
          child: !changed && widget.startValue == true
              ? buildFutureBuilder(loadImages(), (_) => buildTrailing(),
                  fixedWidth: 100)
              : buildTrailing(),
        ));
  }
}
