import 'dart:convert';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:http/http.dart' as http;

class QrPaymentResources {
  static Future getToken({required String prefix}) async {
    var response = await http.get(
      Uri.parse('$tokenUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }

  static Future generateQR({
    required String token,
    required Object body,
  }) async {
    var response = await http.post(
      Uri.parse('https://pegepay.com/api/npd-wa/order-create/custom-validity'),
      body: body,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return json.decode(response.body);
  }

  static Future refreshToken({
    required String prefix,
  }) async {
    var response = await http.post(
      Uri.parse('$tokenUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    return json.decode(response.body);
  }
}
