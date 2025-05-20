import 'dart:convert';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:http/http.dart' as http;

class UploadResources {
  static Future uploadImage(
      {required String prefix, required Object body}) async {
    var response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return json.decode(response.body);
  }

  static Future uploadImageEnYasin(
      {required String prefix, required Object body}) async {
    var response = await http.post(
      Uri.parse('$myEnfocementEnYasinUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return json.decode(response.body);
  }

  static Future uploadCompoundToEnforcementCCP(
      {required String prefix, required Object body}) async {
    var response = await http.post(
      Uri.parse('$baseUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return json.decode(response.body);
  }

  static Future uploadCompoundToEnYasin(
      {required String prefix, required Object body}) async {
    var response = await http.post(
      Uri.parse('$myEnfocementEnYasinUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return json.decode(response.body);
  }

  static Future uploadCompoundToPahangGo(
      {required String prefix, required Object body}) async {
    var response = await http.post(
      Uri.parse('$myEnfocementEnYasinUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return json.decode(response.body);
  }
}
