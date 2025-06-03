import 'dart:convert';
import 'dart:io';
import 'package:eo_apk_mbk_v2/helpers/constant.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UploadResources {
  static Future uploadImage(
      {required String prefix, required Object body}) async {
    var response = await http.post(
      Uri.parse('$backendUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return json.decode(response.body);
  }

  static Future uploadImagePahangGo({
    required String prefix,
    required String compoundNumber,
    required List<File> pictures,
  }) async {
    String token = '5a5dd0ce-f986-4073-96a9-c3bbfe226fd9';

    var uri = Uri.parse('$pahangGoUrl$prefix');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..fields['compound_number'] = compoundNumber;

    // Attach pictures[]
    for (var picture in pictures) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'pictures[]', // important to use the correct key
          picture.path,
          filename: basename(picture.path),
        ),
      );
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed: ${response.statusCode} → ${response.body}');
    }
  }

  static Future uploadCompoundToEnforcementCCP(
      {required String prefix, required Object body}) async {
    var response = await http.post(
      Uri.parse('$backendUrl$prefix'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    return json.decode(response.body);
  }

  static Future uploadCompoundToPahangGo(
      {required String prefix, required Object body}) async {
    String token = '5a5dd0ce-f986-4073-96a9-c3bbfe226fd9';
    var response = await http.post(
      Uri.parse('$pahangGoUrl$prefix'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );
    return json.decode(response.body);
  }
}
