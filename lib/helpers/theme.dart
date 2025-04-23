import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextStyle textStyleNormal({
  Color color = Colors.black,
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.normal,
  TextDecoration decoration = TextDecoration.none,
  Color decorationColor = kBlack,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: "Poppins",
    fontWeight: fontWeight,
    decoration: decoration,
    decorationColor: decorationColor,
    fontStyle: fontStyle,
  );
}

SizedBox spaceVertical({double height = 10}) {
  return SizedBox(height: height);
}

SizedBox spaceHorizontal({double width = 10}) {
  return SizedBox(width: width);
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(), // Convert text to uppercase
      selection: newValue.selection, // Preserve cursor position
    );
  }
}
