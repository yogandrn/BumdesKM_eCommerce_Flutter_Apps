import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BigText extends StatelessWidget {
  final Color? color;
  final String text;
  double size;
  final FontWeight? weight;
  TextOverflow overflow;

  BigText(
      {Key? key,
      this.color = const Color(0xFF000000),
      required this.text,
      this.overflow = TextOverflow.ellipsis,
      this.size = 18,
      this.weight = FontWeight.w600})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      overflow: overflow,
      style: GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
      ),
    );
  }
}
