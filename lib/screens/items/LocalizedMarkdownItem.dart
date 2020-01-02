import 'package:flutter/material.dart';
import 'package:personal_site_app/screens/Zefyr.dart';
import 'package:translator/translator.dart';

class LocalizedString {
  final String ru, en;

  const LocalizedString([this.ru = '', this.en = '']);

  static fromMap(Map map) => LocalizedString(map['ru'], map['en']);

  Map<String, dynamic> toMap() => {'ru': ru, 'en': en};
}

class LocalizedMarkdownItem extends StatefulWidget {
  final String name;
  final Map<String, dynamic> startValue;
  final Function(Map<String, dynamic>) onChanged;
  final TextInputType inputType;
  final translator = GoogleTranslator();
  final bool saveJson, readJson;

  LocalizedMarkdownItem(
    this.name,
    this.onChanged, {
    this.startValue,
    this.inputType = TextInputType.text,
    this.saveJson,
    this.readJson,
  });

  @override
  _LocalizedMarkdownItemState createState() =>
      _LocalizedMarkdownItemState(startValue != null
          ? LocalizedString.fromMap(startValue)
          : const LocalizedString());
}

class _LocalizedMarkdownItemState extends State<LocalizedMarkdownItem> {
  _LocalizedMarkdownItemState(LocalizedString value) {
    debugPrint('value: ' + value.toMap().toString());
    mdRu = value.ru;
    mdEn = value.en;
  }

  String mdRu, mdEn;

  @override
  Widget build(BuildContext ctx) {
    final docRu = '${widget.name}_ru', docEn = '${widget.name}_en';
    return ListTile(
      title: Text(widget.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: SelectableText(mdRu ?? ''),
            width: 100,
          ),
          Container(
            child: SelectableText(mdEn ?? ''),
            width: 100,
          ),
          IconButton(
              icon: Icon(Icons.text_fields),
              onPressed: () async {
                final res = (await Navigator.pushNamed(ctx, ScreenZefyr.route,
                    arguments: ScreenZefyrArgs(mdRu,
                        saveJsonName: widget.saveJson ? docRu : null,
                        fromJsonName: widget.readJson ? docRu : null)));
                debugPrint('zefyr returned: $res');
                if (res != null) {
                  mdRu = res;
                  mdEn = (await widget.translator
                          .translate(mdRu, from: 'ru', to: 'en'))
                      .replaceAll('] (', '](')
                      .replaceAll(': //', '://')
                      .replaceAll(' - ', ' – ')
                      .replaceAll('[ ', '[')
                      .replaceAll(' ]', ']');
                  debugPrint('translated text: $mdEn');
                  setState(() {});
                  widget.onChanged(LocalizedString(mdRu, mdEn).toMap());
                }
              }),
          IconButton(
              icon: Icon(Icons.translate),
              onPressed: () async {
                final res = (await Navigator.pushNamed(
                  ctx,
                  ScreenZefyr.route,
                  arguments: ScreenZefyrArgs(mdEn,
                      saveJsonName: widget.saveJson ? docEn : null,
                      fromJsonName: widget.readJson ? docEn : null),
                ));
                if (res != null) {
                  mdEn = res;
                  widget.onChanged(LocalizedString(mdRu, mdEn).toMap());
                }
              })
        ],
      ),
    );
  }
}
