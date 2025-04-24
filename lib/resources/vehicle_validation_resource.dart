import 'dart:convert';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:http/http.dart' as http;

class VehicleValidationResource {
  static Future validateVehicleEnYasin({
    required String prefix,
    required Object body,
  }) async {
    var response = await http.post(
      Uri.parse('$trafficManagementUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    return json.decode(response.body);
  }

  static Future validateVehicleTrafficManagement({
    required String prefix,
    required String token,
    required Object body,
  }) async {
    var response = await http.post(
      Uri.parse('$trafficManagementUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    return json.decode(response.body);
  }
}
