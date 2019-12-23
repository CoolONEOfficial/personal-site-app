import 'package:flutter/material.dart';
import 'package:flutter_tagging/flutter_tagging.dart';

class TagsItem extends StatefulWidget {
  final String name;
  final List<String> startValue;
  final Function(List<String>) onChanged;

  final TextEditingController textController = TextEditingController();

  TagsItem(this.name, this.onChanged, {this.startValue});

  @override
  _TagsItemState createState() => _TagsItemState(startValue);
}

class _TagsItemState extends State<TagsItem> {
  _TagsItemState(value) {
    if (value is List<String>)
      tags = value.map((mStr) => StrTaggable(mStr)).toList();
  }

  List<StrTaggable> tags = [];

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Text('${widget.name}: ', textScaleFactor: 1,),
          Expanded(
            child: FlutterTagging<StrTaggable>(
              initialItems: tags,
              findSuggestions: (pattern) async {
                return await TagSearchService.getSuggestions(pattern);
              },
              configureSuggestion: (strTag) =>
                  SuggestionConfiguration(title: Text(strTag.str)),
              configureChip: (strTag) => ChipConfiguration(
                label: Text(strTag.str),
              ),
              onChanged: () {
                final tagsStr = tags.map((mTag) => mTag.str).toList();
                debugPrint('tags changed: $tagsStr');
                widget.onChanged(tagsStr);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TagSearchService {
  static const suggestions = [
    'vue',
    'java',
  ];

  static Future<List> getSuggestions(String query) async {
    await Future.delayed(Duration(milliseconds: 200), null);
    List<StrTaggable> tagList =
        suggestions.map((mStr) => StrTaggable(mStr)).toList();
    List<StrTaggable> filteredTagList = <StrTaggable>[];
    if (query.isNotEmpty) {
      filteredTagList.add(StrTaggable(query));
    }
    for (var tag in tagList) {
      if (tag.str.toLowerCase().contains(query)) {
        filteredTagList.add(tag);
      }
    }
    return filteredTagList;
  }
}

class StrTaggable extends Taggable {
  const StrTaggable(this.str);

  final String str;

  @override
  List<Object> get props => [str];
}
