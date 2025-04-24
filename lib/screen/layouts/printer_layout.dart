import 'dart:convert';

import 'package:eo_apk_mbk_v2/helpers/print_document.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class PrinterLayout {
  static getConnection({required String mac}) async {
    BluetoothConnection connection = await BluetoothConnection.toAddress(mac);
    return connection;
  }

  static String settingPrinterLayout({
    required String handHeldId,
    required Map<String, dynamic> userData,
  }) {
    final doc = PrintingDocument("500");
    doc.drawStatusBox(userData, handHeldId);

    String zpl = '''
! U1 setvar "device.languages" "zpl"
^XA
^POI
^FWN
${doc.getLabelLengthCommand()}${doc.getPrintingData()}^XZ
''';

    return zpl;
  }

  static printingProcess({
    required BluetoothConnection connection,
    required String zpl,
  }) async {
    connection.output.add(Utf8Encoder().convert(zpl));
    await connection.output.allSent;

    await Future.delayed(const Duration(seconds: 2));
    await connection.close();
  }
}
