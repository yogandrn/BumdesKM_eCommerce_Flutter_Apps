import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bumdeskm/utils/colors.dart';

class SmallText extends StatelessWidget {
  final Color? color;
  final String text;
  double size, height;
  final TextAlign align;
  final FontWeight? weight;
  bool wrap;

  SmallText(
      {Key? key,
      this.color = const Color(0xFF000000),
      required this.text,
      this.size = 13,
      this.height = 1.2,
      this.weight = FontWeight.w400,
      this.wrap = false,
      this.align = TextAlign.left})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      textAlign: align,
      softWrap: wrap,
      textDirection: TextDirection.ltr,
      // overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      ),
    );
  }
}
