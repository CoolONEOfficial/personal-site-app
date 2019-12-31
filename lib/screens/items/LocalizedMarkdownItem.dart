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
  final translator = new GoogleTranslator();

  LocalizedMarkdownItem(this.name, this.onChanged,
      {this.startValue, this.inputType = TextInputType.text});

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(children: <Widget>[
        Text(
          widget.name,
          textScaleFactor: 1.1,
        ),
        IconButton(
            icon: Icon(Icons.text_fields),
            onPressed: () async {
              final res = (await Navigator.pushNamed(
                ctx,
                ScreenZefyr.route,
                arguments: mdRu
              ));
              mdRu = res;
              mdEn =
                  await widget.translator.translate(mdRu, from: 'ru', to: 'en');
              widget.onChanged(LocalizedString(mdRu, mdEn).toMap());
            }),
        IconButton(
            icon: Icon(Icons.translate),
            onPressed: () async {
              final res = (await Navigator.pushNamed(
                ctx,
                ScreenZefyr.route,
                arguments: mdEn,
              ));
              mdEn = res;
              widget.onChanged(LocalizedString(mdRu, mdEn).toMap());
            }),
      ]),
    );
  }
}
