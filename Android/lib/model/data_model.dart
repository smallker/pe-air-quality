import 'dart:convert';

class DataModel {
  DataModel({
    this.co,
    this.temperature,
    this.humidity,
    this.timestamp,
  });
  double co;
  double temperature;
  double humidity;
  int timestamp;

  factory DataModel.fromJson(String str) => DataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DataModel.fromMap(Map<dynamic, dynamic> json) => DataModel(
        co: json["co"].toDouble(),
        temperature: json["temperature"].toDouble(),
        humidity: json["humidity"].toDouble(),
        timestamp: json["timestamp"] * 1000,
      );

  Map<String, dynamic> toMap() => {
        "co": co,
        "temperature": temperature,
        "humidity": humidity,
        "timestamp": timestamp,
      };
}
