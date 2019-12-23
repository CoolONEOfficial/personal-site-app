import 'package:flutter/material.dart';
import 'package:personal_site_app/screens/items/LocalizedStringItem.dart';
import 'package:place_picker/place_picker.dart';

class Location {
  LocalizedString title;
  final GeoPoint geoPoint;

  Location(this.title, this.geoPoint);

  static fromMap(Map map) => Location(
      LocalizedString.fromMap(map['title']), GeoPoint.fromMap(map['geopoint']));

  Map<String, dynamic> toMap() =>
      {'title': title.toMap(), 'geopoint': geoPoint.toMap()};
}

class GeoPoint {
  final double latitude, longitude;

  const GeoPoint(this.latitude, this.longitude);

  static fromMap(Map map) => GeoPoint(map['latitude'], map['longitude']);

  Map<String, dynamic> toMap() =>
      {'latitude': latitude, 'longitude': longitude};
}

class LocationItem extends StatefulWidget {
  final String name;
  final Map<String, dynamic> startValue;
  final Function(Map<String, dynamic>) onChanged;

  LocationItem(this.name, this.onChanged, {this.startValue});

  @override
  _LocationItemState createState() => _LocationItemState(startValue);
}

class _LocationItemState extends State<LocationItem> {
  _LocationItemState(Map value) {
    if (value != null) {
      locationModel = Location.fromMap(value);
      textControllerEn.text = locationModel.title.en;
      textControllerRu.text = locationModel.title.ru;
    }
  }

  Location locationModel;

  TextEditingController textControllerRu = TextEditingController(),
      textControllerEn = TextEditingController();

  @override
  Widget build(BuildContext ctx) {
    return ListTile(
        title: Text(widget.name),
        subtitle:
            locationModel != null ? Text(locationModel.title.en) : Container(),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 150,
              child: TextField(
                controller: textControllerRu,
                decoration: InputDecoration(hintText: 'Ru'),
                onChanged: (str) {
                  locationModel.title =
                      LocalizedString(str, textControllerEn.text);
                  widget.onChanged(locationModel?.toMap());
                },
              ),
            ),
            Container(
              width: 150,
              child: TextField(
                controller: textControllerEn,
                decoration: InputDecoration(hintText: 'En'),
                onChanged: (str) {
                  locationModel.title =
                      LocalizedString(textControllerRu.text, str);
                  widget.onChanged(locationModel?.toMap());
                },
              ),
            ),
            locationModel != null
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      locationModel = null;
                      setState(() {});
                      widget.onChanged(locationModel?.toMap());
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () async {
                      LocationResult result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PlacePicker(
                            "AIzaSyCijF4pgTurfxRQ1AZ-dzWa53UuQpCCsG4",
                          ),
                        ),
                      );
                      locationModel = Location(
                        LocalizedString(result.name, result.name),
                        GeoPoint(
                          result.latLng.latitude,
                          result.latLng.longitude,
                        ),
                      );
                      textControllerEn.text = result.name;
                      textControllerRu.text = result.name;

                      setState(() {});
                      widget.onChanged(locationModel?.toMap());
                    },
                  ),
          ],
        ));
  }
}
