import 'package:flutter/material.dart';

class LocalizedStringItem extends StatefulWidget {
  final String name;
  final Map<String, dynamic> startValue;
  final Function(Map<String, dynamic>) onChanged;

  LocalizedStringItem(this.name, this.onChanged, {this.startValue});

  @override
  _LocalizedStringItemState createState() =>
      _LocalizedStringItemState(startValue ?? const {"en": "", "ru": ""});
}

class _LocalizedStringItemState extends State<LocalizedStringItem> {
  _LocalizedStringItemState(value) {
    debugPrint('value: ' + value.toString());
    textControllerRu.text = value["ru"];
    textControllerEn.text = value["en"];
  }

  TextEditingController textControllerRu = TextEditingController(),
      textControllerEn = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
      title: Text(widget.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 150,
            child: TextField(
              controller: textControllerRu,
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: 'Ru'),
              onChanged: (str) {
                widget.onChanged({"ru": str, "en": textControllerEn.text});
              },
            ),
          ),
          Container(
            width: 150,
            child: TextField(
              controller: textControllerEn,
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: 'En'),
              onChanged: (str) {
                widget.onChanged({"ru": textControllerRu.text, "en": str});
              },
            ),
          ),
        ],
      ),
    );
  }
}
