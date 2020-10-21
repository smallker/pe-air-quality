import 'package:carousel_slider/carousel_slider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/ui/android/widget/color_material.dart';
import 'package:flutter_template/ui/android/widget/pixel.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String clicked = 'Suhu';
  Widget _header() {
    return Positioned(
      top: Pixel.y * 3,
      left: Pixel.x * 5,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Aktivitas ',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: Pixel.x * 4.5),
            ),
            TextSpan(
              text: 'terakhir',
              style: GoogleFonts.poppins(
                color: ColorMaterial.secondary,
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
              text: 'Polines, Tembalang',
              style: GoogleFonts.poppins(
                color: ColorMaterial.secondary,
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
        color: ColorMaterial.box,
        border: Border.all(
          color: ColorMaterial.secondary,
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
                        color: ColorMaterial.secondary,
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
                    color: ColorMaterial.secondary,
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
      child: Container(
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
              value: 30.0,
              ext: '°C',
              icon: Icons.thermostat_rounded,
            ),
            _sensorBoxItems(
              hint: 'Kelembaban',
              value: 70.0,
              ext: '%',
              icon: Icons.opacity_rounded,
            ),
            _sensorBoxItems(
              hint: 'CO2',
              value: 0.9,
              ext: 'ppm',
              icon: Icons.cloud,
            ),
          ],
        ),
      ),
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
                  color: ColorMaterial.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _dateText() {
    List<String> data = ['Suhu', 'Kelembaban', 'CO2'];
    return data
        .map(
          (e) => InkWell(
            onTap: () => setState(
              () => clicked = e,
            ),
            child: Container(
              padding: EdgeInsets.all(7),
              child: Text(
                e,
                style: GoogleFonts.poppins(
                  fontSize: Pixel.x * 4.5,
                  color: e == clicked ? ColorMaterial.secondary : Colors.white,
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
      child: Container(
        padding: EdgeInsets.only(
          top: Pixel.x * 5,
          bottom: Pixel.x * 5,
        ),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              leftTitles: SideTitles(
                showTitles: true,
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
                  List<String> jam = [
                    '00.00',
                    '01.00',
                    '02.00',
                    '03.00',
                    '04.00',
                    '05.00'
                  ];
                  return jam[value.toInt()];
                },
              ),
            ),
            gridData: FlGridData(
              drawHorizontalLine: true,
            ),
            borderData: FlBorderData(
              border: Border.all(
                color: ColorMaterial.secondary,
              ),
            ),
            maxX: 5,
            maxY: 10,
            minX: 0,
            minY: 0,
            lineBarsData: [
              LineChartBarData(
                colors: [
                  ColorMaterial.secondary,
                ],
                shadow: Shadow(
                  color: ColorMaterial.main,
                  blurRadius: 5,
                ),
                belowBarData: BarAreaData(
                  colors: [
                    ColorMaterial.secondary.withOpacity(0.3),
                  ],
                  show: true,
                ),
                isCurved: true,
                spots: [
                  FlSpot(0, 5),
                  FlSpot(1, 3.44),
                  FlSpot(2, 5),
                  FlSpot(3, 4),
                  FlSpot(4, 7),
                  FlSpot(5, 3.44),
                ],
              ),
            ],
            backgroundColor: ColorMaterial.main,
            axisTitleData: FlAxisTitleData(
              topTitle: AxisTitle(
                titleText: '21 Okt 2020 ($clicked)',
                textStyle: GoogleFonts.poppins(
                  color: Colors.white,
                ),
                showTitle: true,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Pixel().init(context);
    return Container(
      color: ColorMaterial.main,
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
