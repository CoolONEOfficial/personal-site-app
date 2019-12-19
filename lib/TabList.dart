import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:personal_site_app/Item.dart';
import 'package:personal_site_app/components.dart';
import 'package:personal_site_app/main.dart';
import 'package:personal_site_app/screens/EditCreate.dart';
class TabList extends StatefulWidget {
  final String collName;
  final ItemMap itemMap;

  const TabList(this.collName, this.itemMap, {Key key}) : super(key: key);

  @override
  _TabListState createState() => _TabListState();
}

class _TabListState extends State<TabList> {
  @override
  Widget build(BuildContext ctx) {
    return buildFutureBuilder(
        databaseReference.collection(widget.collName).getDocuments(),
            (QuerySnapshot ss) {
          return ListView.builder(
            itemCount: ss.documents.length,
            itemBuilder: (context, index) {
              final mDoc = ss.documents[index];
              return buildFutureBuilder(
                  ItemDoc.fromRootDoc(mDoc),
                      (itemDoc) => Item(
                    itemDoc,
                    widget.itemMap,
                    onEditClicked: () async {
                      final itemData = await ItemData.fromItemDoc(itemDoc);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScreenEditCreate.edit(
                              widget.itemMap, itemData, itemDoc),
                        ),
                      );
                      setState(() {});
                    },
                    onDeleted: () {
                      setState(() {});
                    },
                  ));
            },
          );
        });
  }
}