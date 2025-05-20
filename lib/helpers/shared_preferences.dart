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

    // Ensure the serial starts from 1 instead of 0
    int serial = prefs.getInt(serialNumberKey) ?? 0;
    return serial == 0 ? 1 : serial;
  }

  static Future<void> setNoticeSerialNumber(int serial) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(serialNumberKey, serial);
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

  // Save Form Pending
  static Future<void> saveOfficerCompoundPendingModel(
      OfficerCompoundModel model) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve existing list
    List<String> jsonList =
        prefs.getStringList(officerCompoundModelPendingKey) ?? [];

    // Add new model
    jsonList.add(jsonEncode(model.toJson()));

    // Save updated list
    await prefs.setStringList(officerCompoundModelPendingKey, jsonList);
  }

  // Get Form Pending
  static Future<List<OfficerCompoundModel>>
      getAllOfficerCompoundPendingModels() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> jsonList =
        prefs.getStringList(officerCompoundModelPendingKey) ?? [];

    return jsonList.map((jsonString) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return OfficerCompoundModel.fromJson(jsonMap);
    }).toList();
  }

  static Future<void> removeOfficerCompoundPendingByNoticeNo(
      String noticeNo) async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve existing list
    List<String> jsonList =
        prefs.getStringList(officerCompoundModelPendingKey) ?? [];

    // Decode, filter, and re-encode the list
    List<String> updatedList = jsonList.where((jsonString) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return jsonMap['NoticeNo'] != noticeNo;
    }).toList();

    // Save the filtered list back
    await prefs.setStringList(officerCompoundModelPendingKey, updatedList);
  }

  // Clear Form Pending
  static Future<void> clearOfficerCompoundPendingModel() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(officerCompoundModelPendingKey);
  }

  // Save Form After Push to Server
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

  // Get Form After Push to Server
  static Future<List<OfficerCompoundModel>>
      getAllOfficerCompoundModels() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> jsonList = prefs.getStringList(officerCompoundModelKey) ?? [];

    return jsonList.map((jsonString) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return OfficerCompoundModel.fromJson(jsonMap);
    }).toList();
  }

  static Future<void> saveVerifyVehicleDesc(String verifyDesc) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(verifyDescKey, verifyDesc);
  }

  static Future<String> getVerifyVehicleDesc() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String verifyDesc = prefs.getString(verifyDescKey) ?? '';

    return verifyDesc;
  }

  static Future<void> clearVerifyVehicleDesc() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(verifyDescKey);
  }

  static Future<void> saveImageCount(int count) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(imageCountKey, count);
  }

  static Future<int> getImageCount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt(verifyDescKey) ?? 0;

    return count;
  }

  static Future<void> clearImageCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(imageCountKey);
  }
}
