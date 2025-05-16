import 'package:get/get.dart';
import 'package:eo_apk_mbk_v2/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController(), permanent: true);
  }
}
