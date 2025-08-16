import 'package:eo_apk_mbk_v2/models/models.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';

class CompoundPrintService {
  /// 🔧 Normalize MAC: Accepts both `0017E9D8329F` and `00:17:E9:D8:32:9F`
  static String formatMacAddress(String rawMac) {
    String clean = rawMac.replaceAll(":", "").toUpperCase();
    if (clean.length != 12) return rawMac; // fallback if invalid
    return clean
        .replaceAllMapped(RegExp(r".{2}"), (match) => "${match.group(0)}:")
        .substring(0, 17);
  }

  /// 🔁 Main printing function
  static Future<bool> connectAndPrintDuplicateCopy({
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
    required OfficerCompoundModel model,
    required String qr,
  }) async {
    try {
      String mac = formatMacAddress(rawMac);
      print('🔧 Connecting to printer: $mac');

      final connection = await PrinterLayout.getConnection(mac: mac);
      print('✅ Printer connected');

      final zpl = PrinterLayout.compoundPrinterLayoutDuplicateCopy(
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
        qr: qr,
      );

      print('🖨️ ZPL Generated:\n$zpl');

      await PrinterLayout.printingProcess(connection: connection, zpl: zpl);
      print('✅ Printing completed');
      return true;
    } catch (e) {
      print("❌ Printing failed: $e");
      return false;
    }
  }

  static Future<bool> connectAndPrint({
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
    required OfficerCompoundModel model,
    required String qr,
  }) async {
    try {
      String mac = formatMacAddress(rawMac);
      print('🔧 Connecting to printer: $mac');

      final connection = await PrinterLayout.getConnection(mac: mac);
      print('✅ Printer connected');

      final zpl = PrinterLayout.compoundPrinterLayout(
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
        qr: qr,
      );

      print('🖨️ ZPL Generated:\n$zpl');

      final printerProcessDone =
          await PrinterLayout.printingProcess(connection: connection, zpl: zpl);
      print('✅ Printing completed');

      if (printerProcessDone) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Printing failed inside connectAndPrint: $e");
      return false;
    }
  }
}
