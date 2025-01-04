import 'package:elastic_run/color/er_color.dart';
import 'package:flutter/material.dart';

extension TextExtensions on String {
  Widget normalText({
    double fontSize = 14.0,
    Color color = ErColor.black,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Text(
      this,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        color: color,
      ),
      textAlign: textAlign,
    );
  }

  Widget boldText({
    double fontSize = 14.0,
    Color color = ErColor.black,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Text(
      this,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      textAlign: textAlign,
    );
  }

  Widget semiBoldText({
    double fontSize = 14.0,
    Color color = ErColor.black,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Text(
      this,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      textAlign: textAlign,
    );
  }
}