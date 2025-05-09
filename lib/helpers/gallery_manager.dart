import 'package:flutter/services.dart';

class GalleryManager {
  static const _channel = MethodChannel('com.example.eo_apk_mbk_v2/gallery');

  static Future<bool> deleteImageFromGallery(String fileName) async {
    try {
      final result = await _channel.invokeMethod('deleteFromGallery', {
        'fileName': fileName,
      });
      return result == true;
    } catch (e) {
      print("Error deleting from gallery: $e");
      return false;
    }
  }
}
