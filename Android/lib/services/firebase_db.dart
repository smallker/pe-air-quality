import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_template/controller/data_ctl.dart';
import 'package:flutter_template/model/data_model.dart';
import 'package:get/get.dart';

class FirebaseDb {
  static data() {
    final ctl = Get.put(DataCtl());
    Query ref = FirebaseDatabase.instance
        .reference()
        .child('/sensor/0/logs')
        .limitToLast(6);
    ref.onValue.listen(
      (event) {
        List<DataModel> model = [];
        DataSnapshot snapshot = event.snapshot;
        Map<dynamic, dynamic> logs = snapshot.value;
        try {
          logs.forEach(
            (key, value) {
              model.add(DataModel.fromMap(value));
            },
          );
        } catch (e) {}
        // print(model);
        // model = model.reversed.toList();
        // model.forEach((element) => print(
        //     'temp : ${element.temperature} timestamp : ${DateTime.fromMillisecondsSinceEpoch(element.timestamp)}'));
        model.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        model.reversed.toList();
        ctl.updateData(model);
      },
    );
  }

  static addData() async {
    var ran = Random();
    FirebaseDatabase.instance.reference().child('/sensor/0/logs').push().set(
      {
        'co': ran.nextInt(10),
        'humidity': ran.nextInt(100),
        'temperature': ran.nextInt(32),
        'timestamp':
            (DateTime.now().millisecondsSinceEpoch / 1000).round().toString()
      },
    );
  }

  static getData() {
    var ref = FirebaseDatabase.instance
        .reference()
        .child('/sensor/0/logs')
        // .orderByChild('timestamp')
        .limitToLast(6);
    ref.once().then(
      (value) {
        List<DataModel> data = [];
        Map<dynamic, dynamic> snapshot = value.value;
        snapshot.forEach(
          (key, value) {
            data.add(DataModel.fromMap(value));
          },
        );
        data.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        data.forEach(
          (element) {
            print(DateTime.fromMillisecondsSinceEpoch(element.timestamp));
          },
        );
      },
    );
  }
}
