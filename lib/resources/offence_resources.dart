import 'dart:convert';
import 'dart:io';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OffenceResources {
  static Future<dynamic> getDevice({required String prefix}) async {
    return _retryGetRequest('$backendUrl$prefix');
  }

  static Future<dynamic> _retryGetRequest(String url) async {
    while (true) {
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
        );

        if (response.statusCode == 200) {
          return json.decode(response.body);
        } else {
          if (kDebugMode) {
            print(
              'Server responded with status ${response.statusCode}. Retrying...',
            );
          }
        }
      } on SocketException catch (_) {
        if (kDebugMode) {
          print('🔁 No internet connection. Retrying...');
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Unexpected error: $e');
        }
      }

      await Future.delayed(const Duration(seconds: 2)); // Wait before retrying
    }
  }
}
