import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class LocalizedString {
  final String ru, en;

  const LocalizedString([this.ru = '', this.en = '']);

  static fromMap(Map map) => LocalizedString(map['ru'], map['en']);

  Map<String, dynamic> toMap() => {'ru': ru, 'en': en};
}

class LocalizedStringItem extends StatefulWidget {
  final String name;
  final Map<String, dynamic> startValue;
  final Function(Map<String, dynamic>) onChanged;
  final TextInputType inputType;
  final translator = new GoogleTranslator();

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
    textControllerRu.text = value.ru;
    textControllerEn.text = value.en;
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
              keyboardType: widget.inputType,
              maxLines: widget.inputType == TextInputType.multiline ? null : 1,
              decoration: InputDecoration(hintText: 'Ru'),
              onChanged: (str) {
                widget.onChanged(
                    LocalizedString(str, textControllerEn.text).toMap());
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.translate),
            onPressed: () {
              showDialog(
                  context: ctx,
                  builder: (ctx) => SimpleDialog(
                        title: Text('Translate direction'),
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              FlatButton(
                                child: Text('Ru -> En'),
                                onPressed: () async {
                                  textControllerEn.text = await widget
                                      .translator
                                      .translate(textControllerRu.text,
                                          from: 'ru', to: 'en');
                                  widget.onChanged(LocalizedString(
                                          textControllerRu.text,
                                          textControllerEn.text)
                                      .toMap());
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('Ru <- En'),
                                onPressed: () async {
                                  textControllerRu.text = await widget
                                      .translator
                                      .translate(textControllerEn.text,
                                          from: 'en', to: 'ru');
                                  widget.onChanged(LocalizedString(
                                          textControllerRu.text,
                                          textControllerEn.text)
                                      .toMap());
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          )
                        ],
                      ));
            },
          ),
          Container(
            width: 150,
            child: TextField(
              controller: textControllerEn,
              keyboardType: widget.inputType,
              maxLines: widget.inputType == TextInputType.multiline ? null : 1,
              decoration: InputDecoration(hintText: 'En'),
              onChanged: (str) {
                widget.onChanged(
                    LocalizedString(textControllerRu.text, str).toMap());
              },
            ),
          ),
        ],
      ),
    );
  }
}
