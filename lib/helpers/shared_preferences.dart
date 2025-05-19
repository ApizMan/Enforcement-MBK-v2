import 'dart:convert';

import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:eo_apk_mbk_v2/models/models.dart';
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

  static Future<void> saveTokenTM(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenTMKey, token);
  }

  static Future<String> getTokenTM() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(tokenTMKey) ?? '';

    return token;
  }

  static Future<int> getNoticeSerialNumber() async {
    final prefs = await SharedPreferences.getInstance();

    // Just get the current serial number, no date logic
    return prefs.getInt(serialNumberKey) ?? 0;
  }

  static Future<void> incrementNoticeSerialNumber() async {
    final prefs = await SharedPreferences.getInstance();

    final int current = prefs.getInt(serialNumberKey) ?? 0;
    await prefs.setInt(serialNumberKey, current + 1);

    // Optional: update the date, if you still want to store it
    final String today = DateTime.now().toIso8601String().split('T').first;
    await prefs.setString(serialDateKey, today);
  }

  static Future<void> setCapturedImagePaths(List<String?> paths) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      captureImageCompoundKey,
      paths.map((e) => e ?? '').toList(),
    );
  }

  static Future<List<String?>> getCapturedImagePaths() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList(captureImageCompoundKey) ?? [];
    return list.map((e) => e.isEmpty ? null : e).toList()
      ..addAll(List.filled(4 - list.length, null));
  }

  static Future<void> clearCapturedImagePaths() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(captureImageCompoundKey);
  }

  static Future<void> btnCheckPush({required bool push}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(btnCheckPushKey, push);
  }

  static Future<bool> getCheckPush() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? push = prefs.getBool(btnCheckPushKey);

    return push!;
  }

  // Save Form
  static Future<void> saveOfficerCompoundModel(
      OfficerCompoundModel model) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve existing list
    List<String> jsonList = prefs.getStringList(officerCompoundModelKey) ?? [];

    // Add new model
    jsonList.add(jsonEncode(model.toJson()));

    // Save updated list
    await prefs.setStringList(officerCompoundModelKey, jsonList);
  }

  // Get Form
  static Future<List<OfficerCompoundModel>>
      getAllOfficerCompoundModels() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> jsonList = prefs.getStringList(officerCompoundModelKey) ?? [];

    return jsonList.map((jsonString) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return OfficerCompoundModel.fromJson(jsonMap);
    }).toList();
  }

  // Clear Form
  static Future<void> clearOfficerCompoundModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(officerCompoundModelKey);
  }
}
