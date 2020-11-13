// To parse this JSON data, do
//
//     final deviceModel = deviceModelFromMap(jsonString);

import 'dart:convert';

class DeviceModel {
  DeviceModel({
    this.id,
    this.latitude,
    this.longitude,
    this.location,
  });

  int id;
  double latitude;
  double longitude;
  String location;

  factory DeviceModel.fromJson(String str) =>
      DeviceModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DeviceModel.fromMap(Map<String, dynamic> json) => DeviceModel(
        id: json["id"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        location: json["location"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "location": location,
      };
}
