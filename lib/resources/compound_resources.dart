import 'dart:convert';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:http/http.dart' as http;

class CompoundResources {
  static Future updateImageAfter(
      {required String prefix, required Object body}) async {
    var response = await http.post(
      Uri.parse('$backendUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return json.decode(response.body);
  }
}
