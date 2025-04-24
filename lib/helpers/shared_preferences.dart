import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static Future<void> saveHandheldId(String handHeldId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(handHeldIdKey, handHeldId);
  }

  static Future<String> getHandheldId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String handHeldId = prefs.getString(handHeldIdKey) ?? '';

    return handHeldId;
  }

  static Future<void> saveLoginCredential(
    String userId,
    String name,
    String password,
    String unit,
    String witness,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(loginIdKey, userId);
    prefs.setString(loginNameKey, name);
    prefs.setString(loginPasswordKey, password);
    prefs.setString(loginUnitKey, unit);
    prefs.setString(loginWitnessKey, witness);
  }

  static Future<Map<String, dynamic>> getLoginCredential() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve values from SharedPreferences
    final String? id = prefs.getString(loginIdKey);
    final String? name = prefs.getString(loginNameKey);
    final String? password = prefs.getString(loginPasswordKey);
    final String? unit = prefs.getString(loginUnitKey);
    final String? witness = prefs.getString(loginWitnessKey);

    // Return the values as a Map
    return {
      'id': id,
      'name': name,
      'password': password,
      'unit': unit,
      'witness': witness,
    };
  }

  static Future<void> deleteLoginCredential() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove(loginIdKey);
    await prefs.remove(loginNameKey);
    await prefs.remove(loginPasswordKey);
    await prefs.remove(loginUnitKey);
    await prefs.remove(loginWitnessKey);
  }

  static Future<void> isPrinterNew(bool isPrinterNew) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isPrinterNewKey, isPrinterNew);
  }

  static Future<bool> getPrinterNew() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPrinterNew = prefs.getBool(isPrinterNewKey) ?? false;

    return isPrinterNew;
  }

  static Future<void> savePrinterMAC(String printerMAC, bool isMACSave) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(printerMACKey, printerMAC);
    prefs.setBool(isMACSaveKey, isMACSave);
  }

  static Future<Map<String, dynamic>> getPrinterMAC() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String printerMAC = prefs.getString(printerMACKey) ?? '';
    bool isMACSave = prefs.getBool(isMACSaveKey) ?? false;

    // Return the values as a Map
    return {'printerMAC': printerMAC, 'isMACSave': isMACSave};
  }
}
