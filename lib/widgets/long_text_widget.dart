import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:intl/intl.dart';

class LongText extends StatelessWidget {
  final Color? color;
  final String text;
  double size, height;
  final FontWeight? weight;
  TextAlign? align;
  bool wrap;

  LongText({
    Key? key,
    this.color = const Color(0xFF000000),
    required this.text,
    this.size = 13.2,
    this.height = 1,
    this.weight = FontWeight.w400,
    this.wrap = false,
    this.align = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: wrap,
      textAlign: align,
      maxLines: 20,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      ),
    );
  }
}

class CurrencyFormat {
  static String convertToIdr(dynamic number) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(number);
  }
}
