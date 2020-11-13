import 'package:get/get.dart';

class ChartCtl extends GetxController {
  int chart = 0;
  setChart(int chart) {
    this.chart = chart;
    update();
  }
}
