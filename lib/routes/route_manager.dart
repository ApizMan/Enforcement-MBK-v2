import 'package:eo_apk_mbk_v2/helpers/binding.dart';
import 'package:eo_apk_mbk_v2/screen/screen.dart';
import 'package:get/get.dart';

class RouteManager {
  // Auth
  static const splashScreen = '/splashScreen';
  static const loginScreen = '/loginScreen';

  // Dashboard
  static const homeScreen = '/homeScreen';
  static const settingScreen = '/settingScreen';
  static const compoundParkingScreen = '/compoundParkingScreen';
  static const compoundAmScreen = '/compoundAmScreen';

  // Camera
  static const cameraScreen = '/cameraScreen';

  // Change Body
  static const compoundParkingBody = 'compoundParkingBody';
  static const compoundAmBody = 'compoundAmBody';

  // Duplicate Copy
  static const duplicateCopyParkingScreen = '/duplicateCopyParkingScreen';
  static const duplicateCopyAmScreen = '/duplicateCopyAmScreen';

  static final routes = [
    // Auth
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: loginScreen, page: () => LoginScreen()),

    // Dashboard
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      binding:
          HomeBinding(), // ✅ Inject HomeController before HomeScreen builds
    ),
    GetPage(name: settingScreen, page: () => SettingScreen()),
    GetPage(name: compoundParkingScreen, page: () => CompoundParkingScreen()),
    GetPage(name: compoundAmScreen, page: () => CompoundAmScreen()),

    // Camera
    GetPage(name: cameraScreen, page: () => CameraScreen()),

    // Duplicate Copy
    GetPage(
      name: duplicateCopyParkingScreen,
      page: () => DuplicateCopyParkingScreen(),
    ),
    GetPage(
      name: duplicateCopyAmScreen,
      page: () => DuplicateCopyAmScreen(),
    ),
  ];
}
