import 'package:flutter/material.dart';
import 'package:personal_site_app/Translator.dart';
import 'package:personal_site_app/components.dart';
import 'package:translator/translator.dart';

class LocalizedStringItem extends StatefulWidget {
  final String name;
  final Map<String, dynamic> startValue;
  final Function(Map<String, dynamic>) onChanged;
  final TextInputType inputType;
  final translator = new Translator();

  LocalizedStringItem(this.name, this.onChanged,
      {this.startValue, this.inputType = TextInputType.text});

  @override
  _LocalizedStringItemState createState() =>
      _LocalizedStringItemState(startValue != null
          ? LocalizedString.fromMap(startValue)
          : const LocalizedString());
}

class _LocalizedStringItemState extends State<LocalizedStringItem> {
  _LocalizedStringItemState(LocalizedString value) {
    debugPrint('value: ' + value.toMap().toString());
    textControllerFrom.text = value.original;
    textControllerTo.text = value.translated;
  }

  TextEditingController textControllerFrom = TextEditingController(),
      textControllerTo = TextEditingController();

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
              controller: textControllerFrom,
              keyboardType: widget.inputType,
              maxLines: widget.inputType == TextInputType.multiline ? null : 1,
              decoration: InputDecoration(hintText: 'Ru'),
              onChanged: (str) {
                widget.onChanged(
                    LocalizedString(str, textControllerTo.text).toMap());
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.translate),
            onPressed: () {
              showDialog(
                  context: ctx,
                  builder: (ctx) => buildDialogTranslate(
                        ctx,
                        widget.translator,
                        textControllerFrom.text,
                        textControllerTo.text,
                        (text, lang) {
                          (lang == 'ru' ? textControllerFrom : textControllerTo)
                              .text = text;
                          widget.onChanged(
                            LocalizedString(
                              textControllerFrom.text,
                              textControllerTo.text,
                            ).toMap(),
                          );
                        },
                      )
                  );
            },
          ),
          Container(
            width: 150,
            child: TextField(
              controller: textControllerTo,
              keyboardType: widget.inputType,
              maxLines: widget.inputType == TextInputType.multiline ? null : 1,
              decoration: InputDecoration(hintText: 'En'),
              onChanged: (str) {
                widget.onChanged(
                    LocalizedString(textControllerFrom.text, str).toMap());
              },
            ),
          ),
        ],
      ),
    );
  }
}
