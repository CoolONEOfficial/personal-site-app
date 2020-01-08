import 'package:flutter/material.dart';
import 'package:personal_site_app/Translator.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/constants.dart';
import 'package:personal_site_app/screens/Zefyr.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:translator/translator.dart';

class LocalizedMarkdownItem extends StatefulWidget {
  final String name;
  final Map<String, dynamic> startValue;
  final Function(Map<String, dynamic>) onChanged;
  final TextInputType inputType;
  final translator = Translator();
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
    mdFrom = value.original;
    mdTo = value.translated;
  }

  String mdFrom, mdTo;

  @override
  Widget build(BuildContext ctx) {
    final docRu = '${widget.name}_$FROM_LANG',
        docEn = '${widget.name}_$TO_LANG';
    return ListTile(
      title: Text(widget.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
              onTap: () async {
                final res = (await Navigator.pushNamed(ctx, ScreenZefyr.route,
                    arguments: ScreenZefyrArgs(mdFrom,
                        saveJsonName: widget.saveJson ? docRu : null,
                        fromJsonName: widget.readJson ? docRu : null)));
                if (res != null) {
                  mdFrom = res;
                  widget.onChanged(LocalizedString(mdFrom, mdTo).toMap());
                }
              },
              child: Container(
                child: mdFrom == null || mdFrom.isEmpty
                    ? Text(
                        'Tap here to edit original text',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Text(mdFrom ?? ''),
                width: 100,
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
                        mdFrom,
                        mdTo,
                        (text, lang) {
                          switch (lang) {
                            case FROM_LANG:
                              mdFrom = text;
                              break;
                            case TO_LANG:
                              mdTo = text;
                              break;
                          }
                          widget
                              .onChanged(LocalizedString(mdFrom, mdTo).toMap());
                        },
                      ));
            },
          ),
          InkWell(
            onTap: () async {
              final pr = new ProgressDialog(ctx);
              pr.show();
              final res = (await Navigator.pushNamed(
                ctx,
                ScreenZefyr.route,
                arguments: ScreenZefyrArgs(mdTo,
                    saveJsonName: widget.saveJson ? docEn : null,
                    fromJsonName: widget.readJson ? docEn : null),
              ));
              if (res != null) {
                mdTo = res;
                widget.onChanged(LocalizedString(mdFrom, mdTo).toMap());
              }
              pr.hide();
            },
            child: Container(
              child: mdTo == null || mdTo.isEmpty
                  ? Text(
                      'Tap here to edit translated text',
                      style: TextStyle(color: Colors.grey),
                    )
                  : Text(mdTo ?? ''),
              width: 100,
            ),
          ),
        ],
      ),
    );
  }
}
