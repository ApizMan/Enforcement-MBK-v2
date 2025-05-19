import 'dart:convert';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:http/http.dart' as http;

class OutstandingResource {
  static Future validateLog({
    required String prefix,
    required Object body,
  }) async {
    var response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    return json.decode(response.body);
  }
}
