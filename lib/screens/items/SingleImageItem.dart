import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_site_app/components.dart';

class SingleImageItem extends StatefulWidget {
  final String name;
  final String docPath;
  final bool startValue;
  final Function(ImageProvider) onChanged;

  SingleImageItem(this.name, this.onChanged, {this.startValue, this.docPath});

  @override
  _SingleImageItemState createState() => _SingleImageItemState();
}

class _SingleImageItemState extends State<SingleImageItem> {
  ImageProvider imageProvider;
  bool changed = false;
  bool localSelected = false;

  pickImage() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);

    if (path.extension(image.path) == '.jpg') {
      changed = true;
      imageProvider = FileImage(image);
      localSelected = true;
      setState(() {});
      widget.onChanged(imageProvider);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Only jpg supported!'),
      ));
    }
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
    return ListTile(
        title: Text(widget.name),
        trailing: Container(
          alignment: Alignment.centerRight,
          width: 200,
          child: !changed && widget.startValue == true
              ? buildFutureBuilder(
                  FirebaseStorage.instance
                      .ref()
                      .child('${widget.docPath}/singleImage/1.jpg')
                      .getDownloadURL(), (imageUrl) {
                  imageProvider = NetworkImage(imageUrl);
                  return buildTrailing();
                }, fixedWidth: 100)
              : buildTrailing(),
        ));
  }
}
