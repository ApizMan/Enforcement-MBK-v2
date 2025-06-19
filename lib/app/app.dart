import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:eo_apk_mbk_v2/src/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:eo_apk_mbk_v2/src/localization/app_localizations.dart';

class AppRunner extends StatelessWidget {
  final String? defaultLanguage;
  const AppRunner({super.key, required this.defaultLanguage});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Ensure a non-null locale
    String languageCode = defaultLanguage ?? 'en';

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RouteManager.splashScreen,
      getPages: RouteManager.routes,
      supportedLocales: L10n.all,
      locale: Locale(languageCode),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
