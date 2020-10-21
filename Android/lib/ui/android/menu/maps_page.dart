import 'package:flutter/material.dart';
import 'package:flutter_template/ui/android/widget/pixel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatelessWidget {
  Widget _searchBar() {
    return Positioned(
      top: Pixel.y * 8,
      left: Pixel.x * 5,
      child: Container(
        padding: EdgeInsets.all(
          Pixel.x * 2,
        ),
        width: Pixel.x * 90,
        height: Pixel.y * 10,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.7),
            borderRadius: BorderRadius.circular(
              Pixel.x * 3,
            )),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Cari lokasi',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: Pixel.x * 5,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.search,
                size: Pixel.x * 10,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _maps() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(-7.0528188, 110.4344449),
        zoom: 15,
        tilt: 59,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Pixel().init(context);
    return Container(
      child: Stack(
        children: [
          _maps(),
          _searchBar(),
        ],
      ),
    );
  }
}
