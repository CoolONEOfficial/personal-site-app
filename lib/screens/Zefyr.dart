import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:notus/convert.dart';

class ScreenZefyrArgs {
  final String startMd;
  final String saveJsonName;
  final String fromJsonName;

  ScreenZefyrArgs(
    this.startMd, {
    this.saveJsonName,
    this.fromJsonName,
  });
}

class ScreenZefyr extends StatefulWidget {
  static const route = '/screens/zefyr';

  final ScreenZefyrArgs args;

  const ScreenZefyr(this.args, {Key key}) : super(key: key);

  @override
  ScreenZefyrState createState() => ScreenZefyrState();
}

class ScreenZefyrState extends State<ScreenZefyr> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
  }

  /// Trims start and end whitespace
  String trim(String str) {
    return str
        .replaceFirst(new RegExp(r"^\s+"), "")
        .replaceFirst(new RegExp(r"\s+$"), "");
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return Scaffold(
      appBar: AppBar(
        title: Text("Editor page"),
        // <<< begin change
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                await _saveDocument(context);
                return Navigator.pop(
                  context,
                  trim(notusMarkdown.encode(_controller.document.toDelta())).replaceAll('\n\n', '\n'),
                );
              },
            ),
          )
        ],
        // end change >>>
      ),
      body: (_controller == null)
          ? Center(child: CircularProgressIndicator())
          : ZefyrScaffold(
              child: ZefyrEditor(
                padding: EdgeInsets.all(16),
                controller: _controller,
                focusNode: _focusNode,
              ),
            ),
    );
  }

  /// Loads the document to be edited in Zefyr.
  Future<NotusDocument> _loadDocument() async {
    if ((widget.args.startMd == null || widget.args.startMd.isEmpty) &&
        widget.args.fromJsonName != null) {
      final file =
          File(Directory.systemTemp.path + "/${widget.args.fromJsonName}.json");
      if (await file.exists()) {
        final contents = await file.readAsString();
        return NotusDocument.fromJson(jsonDecode(contents));
      }
    }
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    debugPrint('startData: ${widget.args.startMd}');
    final Delta delta = Delta()..insert('${widget.args.startMd ?? ''}\n');
    return NotusDocument.fromDelta(delta);
  }

  _saveDocument(BuildContext context) {
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    final contents = jsonEncode(_controller.document);
    // For this example we save our document to a temporary file.
    final file =
        File(Directory.systemTemp.path + "/${widget.args.saveJsonName}.json");
    // And show a snack bar on success.
    return file.writeAsString(contents);
  }
}
