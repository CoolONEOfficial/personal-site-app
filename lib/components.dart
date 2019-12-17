import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildFutureBuilder<T>(
  Future<T> future,
  Function(T) builder, {
  double fixedWidth,
}) =>
    FutureBuilder(
      future: future,
      builder: (ctx, ss) =>
          _buildBuilder(ss, builder, buildProgress(fixedWidth: fixedWidth)),
    );

Widget buildStreamBuilder<T>(
  Stream<T> stream,
  Function(T) builder,
) =>
    StreamBuilder(
      stream: stream,
      builder: (ctx, ss) => _buildBuilder(ss, builder, buildProgress()),
    );

Widget _buildFixedWidthProgress(double width) => Container(
      width: width,
      child: buildProgress(),
    );

Widget _buildDefaultProgress() => Center(
      child: Container(
        width: 10,
        height: 10,
        child: CircularProgressIndicator(),
      ),
    );

Widget buildProgress({double fixedWidth}) => fixedWidth != null
    ? _buildFixedWidthProgress(fixedWidth)
    : _buildDefaultProgress();

Widget buildError(String error) => buildMessage(Icons.error, error);

Widget _buildBuilder(AsyncSnapshot ss, builder, progress) => ss.connectionState == ConnectionState.done
    ? builder(ss.data)
    : Center(
        child: ss.hasError ? buildError(ss.error) : progress,
      );

Widget buildMessage(IconData icon, String text) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 100,
              color: Colors.grey,
            ),
          ),
          Text(
            text,
            style: TextStyle(fontSize: 28, color: Colors.grey),
          )
        ],
      ),
    );

Widget buildDialogDelete(
  BuildContext ctx, {
  Function() onDelete,
}) =>
    SimpleDialog(
      title: Text('Вы уверены?'),
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FlatButton(
              child: Text('Удалить'),
              onPressed: () async {
                await onDelete();
                Navigator.of(ctx).pop();
              },
            ),
            FlatButton(
              child: Text('Отмена'),
              onPressed: Navigator.of(ctx).pop,
            )
          ],
        )
      ],
    );