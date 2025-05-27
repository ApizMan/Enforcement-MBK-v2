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

String formatOffenceDate(String rawDate) {
  if (rawDate.length != 14) return rawDate;

  try {
    final year = rawDate.substring(0, 4);
    final month = rawDate.substring(4, 6);
    final day = rawDate.substring(6, 8);
    final hour = rawDate.substring(8, 10);
    final minute = rawDate.substring(10, 12);
    final meridiem = rawDate.substring(12).toUpperCase();

    final formattedDate =
        '$day-$month-$year $hour:$minute:00 ${meridiem.replaceAll('.', '').replaceAllMapped(RegExp(r'([AP])M'), (m) => '${m[1]}.M.')}';

    return formattedDate;
  } catch (_) {
    return rawDate;
  }
}

String formatOffenceDatePahangGo(String rawDate) {
  if (rawDate.length != 14) return rawDate;

  try {
    final year = rawDate.substring(0, 4);
    final month = rawDate.substring(4, 6);
    final day = rawDate.substring(6, 8);
    final hour = rawDate.substring(8, 10);
    final minute = rawDate.substring(10, 12);

    final formattedDate = '$year-$month-$day $hour:$minute:00 ';

    return formattedDate;
  } catch (_) {
    return rawDate;
  }
}
