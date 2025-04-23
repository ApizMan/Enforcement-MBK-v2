import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:get/get.dart';

class RouteManager {
  // Auth
  static const splashScreen = '/splashScreen';
  static const loginScreen = '/loginScreen';

  // Dashboard
  static const homeScreen = '/homeScreen';
  static const settingScreen = '/settingScreen';

  static final routes = [
    // Auth
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),

    // Dashboard
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: settingScreen, page: () => SettingScreen()),
  ];
}
