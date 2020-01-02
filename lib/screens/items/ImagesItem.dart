import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/main.dart';

class ImagesItem extends StatefulWidget {
  final String name;
  final String docPath;
  final bool startValue;
  final Function(List<ImageProvider>) onChanged;

  ImagesItem(this.name, this.onChanged, {this.startValue, this.docPath});

  @override
  _ImagesItemState createState() => _ImagesItemState();

  static Future deleteStorageImages(path, name) async {
    var imageId = 1;
    do {
      final imgStr = '$path/$name/$imageId';
      debugPrint('deleting old images.. $imgStr');
      try {
        await Future.wait([
          storageReference.child('${imgStr}.jpg').delete(),
          storageReference.child('${imgStr}_400x400.jpg').delete()
        ]);
      } catch (e) {
        return;
      }
      imageId++;
    } while (true);
  }
}

class _ImagesItemState extends State<ImagesItem> {
  List<ImageProvider> imagesList = [];
  bool changed = false;
  bool localSelected = false;

  static final Random _random = Random.secure();

  static String generateRandomStr([int length = 32]) {
    final values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }

  pickImages() async {
    final assetList = await MultiImagePicker.pickImages(maxImages: 8);
    for (var mAssetId = 0; mAssetId < assetList.length; mAssetId++) {
      final mAsset = assetList[mAssetId];
      final imgPath =
          '${(await getApplicationDocumentsDirectory()).path}/images/${widget.docPath ?? generateRandomStr()}/${(mAssetId + 1).toString()}.jpg';
      debugPrint('imgPath: $imgPath');
      final File f = await File(imgPath).create(recursive: true);
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
          children: (imagesList
              .map<Widget>((mImage) => mImage != null ? Image(
                    image: mImage,
                  ) : Container())
              .toList()
              .sublist(0, imagesList.length > 3 ? 3 : imagesList.length)
                ..add(IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: deleteImage,
                ))) ?? [],
        );

  loadImages() async {
    var imageId = 1;
    do {
      debugPrint('image num $imageId');
      try {
        final imgPath = '${widget.docPath}/images/$imageId.jpg';
        debugPrint('mPath: $imgPath');
        final src = (await storageReference.child(imgPath).getDownloadURL()) ?? '';
        debugPrint('src: $src');
        imagesList.add(
          NetworkImage(
            src,
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
        trailing: !changed && widget.startValue == true
            ? buildFutureBuilder(
                loadImages(),
                (_) => buildTrailing(),
                fixedWidth: 100,
              )
            : buildTrailing());
  }
}
