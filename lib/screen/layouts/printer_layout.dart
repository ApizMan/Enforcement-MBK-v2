import 'dart:convert';

import 'package:eo_apk_mbk_v2/helpers/print_document.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class PrinterLayout {
  static getConnection({required String mac}) async {
    try {
      final connection = await BluetoothConnection.toAddress(mac);
      print("✅ Connected to Bluetooth: $mac");
      return connection;
    } catch (e) {
      print("❌ Failed to connect to Bluetooth: $e");
      rethrow;
    }
  }

  static String settingPrinterLayout({
    required String handHeldId,
    required Map<String, dynamic> userData,
    required int compoundTotal,
    required int compoundPendingTotal,
    required int countImage,
  }) {
    final doc = PrintingDocument("500");
    doc.drawStatusBox(
      userData: userData,
      handHeldId: handHeldId,
      compoundTotal: compoundTotal,
      compoundPendingTotal: compoundPendingTotal,
      countImage: countImage,
    );

    String zpl = '''
! U1 setvar "device.languages" "zpl"
^XA
^POI
^FWN
${doc.getLabelLengthCommand()}${doc.getPrintingData()}^XZ
''';

    return zpl;
  }

  static String compoundPrinterLayoutDuplicateCopy({
    required final OfficerCompoundModel model,
    required String rawMac,
    required List<UserModel> userModel,
    required List<OfficerUnitModel> unitModel,
    required String handHeldId,
    required List<VehicleTypeModel> vehicleTypeModel,
    required List<VehicleBrandModel> vehicleMakesModel,
    required List<VehicleModelsModel> vehicleModelsModel,
    required List<VehicleColorModel> vehicleColorModel,
    required List<OffenceActModel> offenceActModel,
    required List<OffenceSectionModel> offenceSectionModel,
    required List<OffenceAreaModel> offenceAreaModel,
    required List<OffenceLocationModel> offenceLocationModel,
  }) {
    final doc = PrintingDocument('500').createNoticeDuplicateCopy(
      model: model,
      handHeldId: handHeldId,
      rawMac: rawMac,
      userModel: userModel,
      unitModel: unitModel,
      offenceActModel: offenceActModel,
      offenceAreaModel: offenceAreaModel,
      offenceLocationModel: offenceLocationModel,
      offenceSectionModel: offenceSectionModel,
      vehicleColorModel: vehicleColorModel,
      vehicleMakesModel: vehicleMakesModel,
      vehicleModelsModel: vehicleModelsModel,
      vehicleTypeModel: vehicleTypeModel,
    );

    String zpl = '''
! U1 setvar "device.languages" "zpl"
^XA
^POI
^FWN
${doc.getLabelLengthCommand()}${doc.getPrintingData()}^XZ
''';

    return zpl;
  }

  static String compoundPrinterLayout({
    required final OfficerCompoundModel model,
    required String rawMac,
    required List<UserModel> userModel,
    required List<OfficerUnitModel> unitModel,
    required String handHeldId,
    required List<VehicleTypeModel> vehicleTypeModel,
    required List<VehicleBrandModel> vehicleMakesModel,
    required List<VehicleModelsModel> vehicleModelsModel,
    required List<VehicleColorModel> vehicleColorModel,
    required List<OffenceActModel> offenceActModel,
    required List<OffenceSectionModel> offenceSectionModel,
    required List<OffenceAreaModel> offenceAreaModel,
    required List<OffenceLocationModel> offenceLocationModel,
  }) {
    final doc = PrintingDocument('500').createNotice(
      model: model,
      handHeldId: handHeldId,
      rawMac: rawMac,
      userModel: userModel,
      unitModel: unitModel,
      offenceActModel: offenceActModel,
      offenceAreaModel: offenceAreaModel,
      offenceLocationModel: offenceLocationModel,
      offenceSectionModel: offenceSectionModel,
      vehicleColorModel: vehicleColorModel,
      vehicleMakesModel: vehicleMakesModel,
      vehicleModelsModel: vehicleModelsModel,
      vehicleTypeModel: vehicleTypeModel,
    );

    String zpl = '''
! U1 setvar "device.languages" "zpl"
^XA
^POI
^FWN
${doc.getLabelLengthCommand()}${doc.getPrintingData()}^XZ
''';

    return zpl;
  }

  static Future<bool> printingProcess({
    required BluetoothConnection connection,
    required String zpl,
  }) async {
    try {
      print("📤 Sending ZPL...");
      connection.output.add(Utf8Encoder().convert(zpl));
      await connection.output.allSent;
      print("✅ ZPL sent successfully");

      await Future.delayed(const Duration(seconds: 2)); // Let it print

      try {
        print("🔌 Attempting to close Bluetooth connection...");
        await connection.close().timeout(const Duration(seconds: 1));
        print("✅ Bluetooth connection closed successfully");
      } catch (closeError) {
        print(
            "⚠️ Failed to close connection cleanly or timed out: $closeError");
      }

      print("✅ Printing completed"); // Now always reached
      return true;
    } catch (e) {
      print("❌ Error during printing process: $e");
      return false;
    }
  }
}
