import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/main.dart';

class ImageSingleItem extends StatefulWidget {
  final String name;
  final String docPath;
  final String startValue;
  final Function(ImageProvider) onChanged;

  ImageSingleItem(
    this.name,
    this.onChanged, {
    this.startValue,
    this.docPath,
  });

  @override
  _ImageSingleItemState createState() => _ImageSingleItemState();

  static Future deleteStorageSingleImage(
      String path, String name, String ext) async {
    final imgStr = '$path/$name/';
    debugPrint('deleting old singleimage.. $imgStr ext: $ext');
    try {
      await Future.wait([
        storageReference.child('${imgStr}1$ext').delete(),
        storageReference.child('${imgStr}1_400x400$ext').delete()
      ]);
    } catch (e) {
      debugPrint('error while deleting singleimage: $e');
    }
  }
}

class _ImageSingleItemState extends State<ImageSingleItem> {
  ImageProvider imageProvider;
  bool changed = false;
  bool localSelected = false;

  pickImage() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);

    changed = true;
    imageProvider = FileImage(image);
    localSelected = true;
    setState(() {});
    widget.onChanged(imageProvider);
  }

  deleteImage() {
    changed = true;
    imageProvider = null;
    localSelected = false;
    setState(() {});
    widget.onChanged(null);
  }

  Widget buildTrailing() => imageProvider == null
      ? IconButton(
          icon: Icon(Icons.image),
          onPressed: pickImage,
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Image(
              image: imageProvider,
              width: 70,
              height: 70,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteImage,
            ),
          ],
        );

  @override
  Widget build(BuildContext ctx) {
    debugPrint('start val: ${widget.startValue}');
    return ListTile(
        title: Text(widget.name),
        trailing: !changed && widget.startValue != null
            ? buildFutureBuilder(
                storageReference
                    .child('${widget.docPath}/${widget.name}/1${widget.startValue}')
                    .getDownloadURL(),
                (imageUrl) {
                  imageProvider = NetworkImage(imageUrl);
                  return buildTrailing();
                },
                fixedWidth: 100,
              )
            : buildTrailing());
  }
}
