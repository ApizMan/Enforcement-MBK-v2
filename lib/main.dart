import 'package:eo_apk_mbk_v2/app/app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppRunner(defaultLanguage: 'ms'));
}
