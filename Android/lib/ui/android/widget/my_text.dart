import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class MyText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final TextAlign align;
  const MyText({Key key, this.text, this.color, this.fontSize, this.align})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: fontSize,
      ),
      textAlign: align == null ? TextAlign.left : align,
    );
  }
}
