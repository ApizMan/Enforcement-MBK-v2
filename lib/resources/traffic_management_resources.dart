import 'dart:convert';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:http/http.dart' as http;

class TrafficManagementResources {
  static Future reloadToken({required String prefix}) async {
    var response = await http.post(
      Uri.parse('$trafficManagementUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }
}
