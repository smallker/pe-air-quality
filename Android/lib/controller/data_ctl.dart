import 'package:flutter_template/model/data_model.dart';
import 'package:get/get.dart';

class DataCtl extends GetxController {
  List<DataModel> data = [];
  DataModel livedata;
  updateData(List<DataModel> data) {
    this.data = data;
    this.livedata = data.last;
    update();
  }
}
