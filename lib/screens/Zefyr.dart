import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'package:notus/convert.dart';

class ScreenZefyr extends StatefulWidget {
  static const route = '/screens/zefyr';

  final String startMd;

  const ScreenZefyr(this.startMd, {Key key}) : super(key: key);

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
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
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
              onPressed: () => Navigator.pop(context,
                  notusMarkdown.encode(_controller.document.toDelta())),
            ),
          )
        ],
        // end change >>>
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),
    );
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    debugPrint('startData: ${widget.startMd}');
    final Delta delta = Delta()..insert('${widget.startMd}\n');
    return NotusDocument.fromDelta(delta);
  }
}
