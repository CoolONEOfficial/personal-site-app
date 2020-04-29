import 'package:flutter/material.dart';
import 'package:personal_site_app/Translator.dart';
import 'package:personal_site_app/constants.dart';
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
      textControllerEn.text = locationModel.title.translated;
      textControllerRu.text = locationModel.title.original;
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
            locationModel != null ? Text(locationModel.title.translated) : Container(),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 100,
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
              width: 100,
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
                            builder: (context) =>
                                PlacePicker(GOOGLE_MAPS_API_KEY)),
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
