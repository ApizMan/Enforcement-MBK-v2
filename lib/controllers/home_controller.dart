import 'package:eo_apk_mbk_v2/routes/route_manager.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentScreen = RouteManager.compoundParkingBody.obs;

  void setScreen(String screen) {
    currentScreen.value = screen;
  }
}
