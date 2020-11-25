import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/controller/chart_ctl.dart';
import 'package:flutter_template/controller/data_ctl.dart';
import 'package:flutter_template/ui/android/widget/my_colors.dart';
import 'package:flutter_template/ui/android/widget/pixel.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String clicked = 'Suhu';
  final chartCtl = Get.put(ChartCtl());
  Widget _header() {
    return Positioned(
      top: Pixel.y * 3,
      left: Pixel.x * 5,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Air Quality ',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: Pixel.x * 4.5),
            ),
            TextSpan(
              text: 'Monitoring',
              style: GoogleFonts.poppins(
                color: MyColors.secondary,
                fontSize: Pixel.x * 4.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeName() {
    return Positioned(
      top: Pixel.y * 7,
      left: Pixel.x * 5,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Data Realtime',
              style: GoogleFonts.poppins(
                color: MyColors.secondary,
                fontSize: Pixel.x * 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sensorBoxItems(
      {String hint, double value, IconData icon, String ext}) {
    return Container(
      decoration: BoxDecoration(
        color: MyColors.box,
        border: Border.all(
          color: MyColors.secondary,
          width: Pixel.x * 0.3,
        ),
        borderRadius: BorderRadius.circular(Pixel.x * 5),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: SizedBox(
                    width: Pixel.x * 50,
                    child: Text(
                      hint,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.poppins(
                        color: MyColors.secondary,
                        fontSize: Pixel.x * 5,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(
                    icon,
                    size: Pixel.x * 8,
                    color: MyColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '$value $ext',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: Pixel.x * 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sensorBox() {
    return Positioned(
      top: Pixel.y * 15,
      width: Pixel.x * 100,
      height: Pixel.y * 25,
      child: GetBuilder<DataCtl>(
          init: DataCtl(),
          builder: (event) {
            return Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: Pixel.y * 25,
                  aspectRatio: 2 / 4,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items: [
                  _sensorBoxItems(
                    hint: 'Suhu',
                    value: event.livedata == null
                        ? 0.0
                        : event.livedata.temperature,
                    ext: '°C',
                    icon: Icons.thermostat_rounded,
                  ),
                  _sensorBoxItems(
                    hint: 'Kelembaban',
                    value: event.livedata == null ? 0 : event.livedata.humidity,
                    ext: '%',
                    icon: Icons.opacity_rounded,
                  ),
                  _sensorBoxItems(
                    hint: 'CO',
                    value: event.livedata == null ? 0 : event.livedata.co,
                    ext: 'ppm',
                    icon: Icons.cloud,
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _textGraphTitle() {
    return Positioned(
      top: Pixel.y * 45,
      left: Pixel.x * 5,
      child: Container(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Grafik ',
                style: GoogleFonts.poppins(
                  fontSize: Pixel.x * 5,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: ' data sensor',
                style: GoogleFonts.poppins(
                  fontSize: Pixel.x * 5,
                  color: MyColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _dateText() {
    List<String> data = ['Suhu', 'Kelembaban', 'CO'];
    return data
        .map(
          (e) => InkWell(
            onTap: () {
              chartCtl.setChart(data.indexWhere((element) => element == e));
              setState(() {
                clicked = e;
              });
            },
            child: Container(
              padding: EdgeInsets.all(7),
              child: Text(
                e,
                style: GoogleFonts.poppins(
                  fontSize: Pixel.x * 4.5,
                  color: e == clicked ? MyColors.secondary : Colors.white,
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _lastDay() {
    return Positioned(
      top: Pixel.y * 50,
      left: Pixel.x * 5,
      width: Pixel.x * 90,
      child: Row(
        children: _dateText(),
      ),
    );
  }

  Widget _chartData() {
    return Positioned(
      top: Pixel.y * 57,
      left: Pixel.x * 2,
      width: Pixel.x * 90,
      height: Pixel.y * 35,
      child: GetBuilder<DataCtl>(
        init: DataCtl(),
        builder: (event) {
          if (event.livedata == null)
            return Container(
              margin: EdgeInsets.all(Pixel.x * 5),
              decoration: BoxDecoration(
                color: MyColors.main,
                borderRadius: BorderRadius.circular(Pixel.x * 5),
                border: Border.all(
                  color: MyColors.secondary,
                  width: Pixel.x * 0.3,
                ),
              ),
              child: Center(
                child: Text(
                  'Belum ada data',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: Pixel.x * 5,
                  ),
                ),
              ),
            );
          var dataCo = LineChartData(
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
                interval: event.data
                        .reduce((value, element) =>
                            value.co > element.co ? value : element)
                        .co /
                    5,
                getTextStyles: (value) => GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: Pixel.x * 3,
                ),
              ),
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: Pixel.x * 3,
                ),
                reservedSize: 25,
                getTitles: (value) {
                  var d = DateTime.fromMillisecondsSinceEpoch(
                    event.data[value.toInt()].timestamp,
                  ).toString().split(' ')[1].split(':');
                  return (d[0] + ':' + d[1]);
                },
              ),
            ),
            gridData: FlGridData(
              drawHorizontalLine: true,
              horizontalInterval: event.data
                      .reduce((value, element) =>
                          value.co > element.co ? value : element)
                      .co /
                  5,
            ),
            borderData: FlBorderData(
              border: Border.all(
                color: MyColors.secondary,
              ),
            ),
            maxX: (event.data.length - 1).toDouble(),
            maxY: event.data
                .reduce(
                    (value, element) => value.co > element.co ? value : element)
                .co,
            minX: 0,
            minY: 0,
            lineBarsData: [
              LineChartBarData(
                colors: [
                  MyColors.secondary,
                ],
                shadow: Shadow(
                  color: MyColors.main,
                  blurRadius: 5,
                ),
                belowBarData: BarAreaData(
                  colors: [
                    MyColors.secondary.withOpacity(0.3),
                  ],
                  show: true,
                ),
                isCurved: true,
                spots: [
                  FlSpot(0, event.data[0].co),
                  FlSpot(1, event.data[1].co),
                  FlSpot(2, event.data[2].co),
                  FlSpot(3, event.data[3].co),
                  FlSpot(4, event.data[4].co),
                  FlSpot(5, event.data[5].co),
                ],
              ),
            ],
            backgroundColor: MyColors.main,
            axisTitleData: FlAxisTitleData(
              topTitle: AxisTitle(
                titleText:
                    '${DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(event.data.last.timestamp))} ($clicked)',
                textStyle: GoogleFonts.poppins(
                  color: Colors.white,
                ),
                showTitle: true,
              ),
            ),
          );
          var dataHum = LineChartData(
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
                interval: 25,
                getTextStyles: (value) => GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: Pixel.x * 3,
                ),
              ),
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: Pixel.x * 3,
                ),
                reservedSize: 25,
                getTitles: (value) {
                  var d = DateTime.fromMillisecondsSinceEpoch(
                    event.data[value.toInt()].timestamp,
                  ).toString().split(' ')[1].split(':');
                  return (d[0] + ':' + d[1]);
                },
              ),
            ),
            gridData: FlGridData(
              drawHorizontalLine: true,
              horizontalInterval: 25,
            ),
            borderData: FlBorderData(
              border: Border.all(
                color: MyColors.secondary,
              ),
            ),
            maxX: (event.data.length - 1).toDouble(),
            maxY: 100,
            minX: 0,
            minY: 0,
            lineBarsData: [
              LineChartBarData(
                colors: [
                  MyColors.secondary,
                ],
                shadow: Shadow(
                  color: MyColors.main,
                  blurRadius: 5,
                ),
                belowBarData: BarAreaData(
                  colors: [
                    MyColors.secondary.withOpacity(0.3),
                  ],
                  show: true,
                ),
                isCurved: true,
                spots: [
                  FlSpot(0, event.data[0].humidity),
                  FlSpot(1, event.data[1].humidity),
                  FlSpot(2, event.data[2].humidity),
                  FlSpot(3, event.data[3].humidity),
                  FlSpot(4, event.data[4].humidity),
                  FlSpot(5, event.data[5].humidity),
                ],
              ),
            ],
            backgroundColor: MyColors.main,
            axisTitleData: FlAxisTitleData(
              topTitle: AxisTitle(
                titleText:
                    '${DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(event.data.last.timestamp))} ($clicked)',
                textStyle: GoogleFonts.poppins(
                  color: Colors.white,
                ),
                showTitle: true,
              ),
            ),
          );
          var dataTemp = LineChartData(
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
                interval: 5,
                getTextStyles: (value) => GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: Pixel.x * 3,
                ),
              ),
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: Pixel.x * 3,
                ),
                reservedSize: 25,
                getTitles: (value) {
                  var d = DateTime.fromMillisecondsSinceEpoch(
                    event.data[value.toInt()].timestamp,
                  ).toString().split(' ')[1].split(':');
                  return (d[0] + ':' + d[1]);
                },
              ),
            ),
            gridData: FlGridData(
              drawHorizontalLine: true,
              horizontalInterval: 5,
            ),
            borderData: FlBorderData(
              border: Border.all(
                color: MyColors.secondary,
              ),
            ),
            maxX: (event.data.length - 1).toDouble(),
            maxY: event.data
                .reduce((value, element) =>
                    value.temperature > element.temperature ? value : element)
                .temperature,
            minX: 0,
            minY: 0,
            lineBarsData: [
              LineChartBarData(
                colors: [
                  MyColors.secondary,
                ],
                shadow: Shadow(
                  color: MyColors.main,
                  blurRadius: 5,
                ),
                belowBarData: BarAreaData(
                  colors: [
                    MyColors.secondary.withOpacity(0.3),
                  ],
                  show: true,
                ),
                isCurved: true,
                spots: [
                  FlSpot(0, event.data[0].temperature),
                  FlSpot(1, event.data[1].temperature),
                  FlSpot(2, event.data[2].temperature),
                  FlSpot(3, event.data[3].temperature),
                  FlSpot(4, event.data[4].temperature),
                  FlSpot(5, event.data[5].temperature),
                ],
              ),
            ],
            backgroundColor: MyColors.main,
            axisTitleData: FlAxisTitleData(
              topTitle: AxisTitle(
                titleText:
                    '${DateFormat.yMMMMd().format(DateTime.fromMillisecondsSinceEpoch(event.data.last.timestamp))} ($clicked)',
                textStyle: GoogleFonts.poppins(
                  color: Colors.white,
                ),
                showTitle: true,
              ),
            ),
          );
          List<LineChartData> lineChart = [
            dataTemp,
            dataHum,
            dataCo,
          ];
          return GetBuilder<ChartCtl>(
            init: ChartCtl(),
            builder: (chart) {
              return Container(
                padding: EdgeInsets.only(
                  top: Pixel.x * 5,
                  bottom: Pixel.x * 5,
                ),
                child: LineChart(
                  lineChart[chart.chart],
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Pixel().init(context);
    return Container(
      color: MyColors.main,
      child: Stack(
        children: [
          _header(),
          _placeName(),
          _sensorBox(),
          _textGraphTitle(),
          _lastDay(),
          _chartData(),
        ],
      ),
    );
  }
}
