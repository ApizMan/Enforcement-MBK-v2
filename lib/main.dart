import 'package:eo_apk_mbk_v2/app/app.dart';
import 'package:eo_apk_mbk_v2/helpers/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesHelper.clearVerifyVehicleDesc();

  await SharedPreferencesHelper
      .deleteOldGalleryImages(); // run before app starts

  runApp(const AppRunner(defaultLanguage: 'ms'));
}
